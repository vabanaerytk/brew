# typed: true
# frozen_string_literal: true

require "cask/cache"
require "cask/cask"
require "uri"
require "utils/curl"
require "extend/hash/keys"

module Cask
  # Loads a cask from various sources.
  #
  # @api private
  module CaskLoader
    extend Context

    module ILoader
      extend T::Helpers
      interface!

      sig { abstract.params(config: Config).returns(Cask) }
      def load(config:); end
    end

    # Loads a cask from a string.
    class AbstractContentLoader
      include ILoader
      extend T::Helpers
      abstract!

      sig { returns(String) }
      attr_reader :content

      sig { returns(T.nilable(Tap)) }
      attr_reader :tap

      private

      sig {
        overridable.params(
          header_token: String,
          options:      T.untyped,
          block:        T.nilable(T.proc.bind(DSL).void),
        ).returns(Cask)
      }
      def cask(header_token, **options, &block)
        Cask.new(header_token, source: content, tap: tap, **options, config: @config, &block)
      end
    end

    # Loads a cask from a string.
    class FromContentLoader < AbstractContentLoader
      def self.try_new(ref, warn: false)
        return false unless ref.respond_to?(:to_str)

        content = T.unsafe(ref).to_str

        # Cache compiled regex
        @regex ||= begin
          token  = /(?:"[^"]*"|'[^']*')/
          curly  = /\(\s*#{token.source}\s*\)\s*\{.*\}/
          do_end = /\s+#{token.source}\s+do(?:\s*;\s*|\s+).*end/
          /\A\s*cask(?:#{curly.source}|#{do_end.source})\s*\Z/m
        end

        return unless content.match?(@regex)

        new(content)
      end

      sig { params(content: String, tap: Tap).void }
      def initialize(content, tap: T.unsafe(nil))
        super()

        @content = content.dup.force_encoding("UTF-8")
        @tap = tap
      end

      def load(config:)
        @config = config

        instance_eval(content, __FILE__, __LINE__)
      end
    end

    # Loads a cask from a path.
    class FromPathLoader < AbstractContentLoader
      sig {
        params(ref: T.any(String, Pathname, Cask, URI::Generic), warn: T::Boolean)
          .returns(T.nilable(T.attached_class))
      }
      def self.try_new(ref, warn: false)
        path = case ref
        when String
          Pathname(ref)
        when Pathname
          ref
        else
          return
        end

        return if %w[.rb .json].exclude?(path.extname)
        return unless path.expand_path.exist?

        new(path)
      end

      attr_reader :token, :path

      sig { params(path: T.any(Pathname, String), token: String).void }
      def initialize(path, token: T.unsafe(nil))
        super()

        path = Pathname(path).expand_path

        @token = path.basename(path.extname).to_s
        @path = path
        @tap = Tap.from_path(path) || Homebrew::API.tap_from_source_download(path)
      end

      def load(config:)
        raise CaskUnavailableError.new(token, "'#{path}' does not exist.")  unless path.exist?
        raise CaskUnavailableError.new(token, "'#{path}' is not readable.") unless path.readable?
        raise CaskUnavailableError.new(token, "'#{path}' is not a file.")   unless path.file?

        @content = path.read(encoding: "UTF-8")
        @config = config

        if path.extname == ".json"
          return FromAPILoader.new(token, from_json: JSON.parse(@content)).load(config: config)
        end

        begin
          instance_eval(content, path).tap do |cask|
            raise CaskUnreadableError.new(token, "'#{path}' does not contain a cask.") unless cask.is_a?(Cask)
          end
        rescue NameError, ArgumentError, ScriptError => e
          error = CaskUnreadableError.new(token, e.message)
          error.set_backtrace e.backtrace
          raise error
        end
      end

      private

      def cask(header_token, **options, &block)
        raise CaskTokenMismatchError.new(token, header_token) if token != header_token

        super(header_token, **options, sourcefile_path: path, &block)
      end
    end

    # Loads a cask from a URI.
    class FromURILoader < FromPathLoader
      sig {
        params(ref: T.any(String, Pathname, Cask, URI::Generic), warn: T::Boolean)
          .returns(T.nilable(T.attached_class))
      }
      def self.try_new(ref, warn: false)
        # Cache compiled regex
        @uri_regex ||= begin
          uri_regex = ::URI::DEFAULT_PARSER.make_regexp
          Regexp.new("\\A#{uri_regex.source}\\Z", uri_regex.options)
        end

        uri = ref.to_s
        return unless uri.match?(@uri_regex)

        uri = URI(uri)
        return unless uri.path

        new(uri)
      end

      attr_reader :url

      sig { params(url: T.any(URI::Generic, String)).void }
      def initialize(url)
        @url = URI(url)
        super Cache.path/File.basename(T.must(@url.path))
      end

      def load(config:)
        path.dirname.mkpath

        begin
          ohai "Downloading #{url}"
          ::Utils::Curl.curl_download url, to: path
        rescue ErrorDuringExecution
          raise CaskUnavailableError.new(token, "Failed to download #{Formatter.url(url)}.")
        end

        super
      end
    end

    # Loads a cask from a specific tap.
    class FromTapLoader < FromPathLoader
      sig {
        params(ref: T.any(String, Pathname, Cask, URI::Generic), warn: T::Boolean)
          .returns(T.nilable(T.attached_class))
      }
      def self.try_new(ref, warn: false)
        ref = ref.to_s

        return unless ref.match?(HOMEBREW_TAP_CASK_REGEX)

        token, tap, = CaskLoader.tap_cask_token_type(ref, warn: warn)
        new("#{tap}/#{token}")
      end

      sig { params(tapped_token: String).void }
      def initialize(tapped_token)
        user, repo, token = tapped_token.split("/", 3)
        tap = Tap.fetch(user, repo)
        cask = CaskLoader.find_cask_in_tap(token, tap)
        super cask
      end

      def load(config:)
        raise TapCaskUnavailableError.new(tap, token) unless T.must(tap).installed?

        super
      end
    end

    # Load a cask from the default tap, using either a full or short token.
    class FromDefaultTapLoader < FromTapLoader
      sig {
        params(ref: T.any(String, Pathname, Cask, URI::Generic), warn: T::Boolean)
          .returns(T.nilable(T.attached_class))
      }
      def self.try_new(ref, warn: false)
        ref = ref.to_s

        return unless (match = ref.match(HOMEBREW_DEFAULT_TAP_CASK_REGEX))

        token = match[:token]

        ref = "#{CoreCaskTap.instance}/#{token}"

        token, tap, = CaskLoader.tap_cask_token_type(ref, warn: warn)
        new("#{tap}/#{token}")
      end
    end

    # Loads a cask from the default tap path.
    class FromDefaultTapPathLoader < FromPathLoader
      sig {
        params(ref: T.any(String, Pathname, Cask, URI::Generic), warn: T::Boolean)
          .returns(T.nilable(T.attached_class))
      }
      def self.try_new(ref, warn: false)
        super CaskLoader.default_path(ref)
      end
    end

    # Loads a cask from an existing {Cask} instance.
    class FromInstanceLoader
      include ILoader

      sig {
        params(ref: T.any(String, Pathname, Cask, URI::Generic), warn: T::Boolean)
          .returns(T.nilable(T.attached_class))
      }
      def self.try_new(ref, warn: false)
        new(ref) if ref.is_a?(Cask)
      end

      sig { params(cask: Cask).void }
      def initialize(cask)
        @cask = cask
      end

      def load(config:)
        @cask
      end
    end

    # Loads a cask from the JSON API.
    class FromAPILoader
      include ILoader

      sig { returns(String) }
      attr_reader :token

      sig { returns(Pathname) }
      attr_reader :path

      sig { returns(T.nilable(Hash)) }
      attr_reader :from_json

      sig {
        params(ref: T.any(String, Pathname, Cask, URI::Generic), warn: T::Boolean)
          .returns(T.nilable(T.attached_class))
      }
      def self.try_new(ref, warn: false)
        return if Homebrew::EnvConfig.no_install_from_api?
        return unless ref.is_a?(String)

        return unless (match = ref.match(HOMEBREW_DEFAULT_TAP_CASK_REGEX))

        token = T.cast(match[:token], String)
        return if !Homebrew::API::Cask.all_casks.key?(token) && !Homebrew::API::Cask.all_renames.key?(token)

        ref = "#{CoreCaskTap.instance}/#{token}"

        token, tap, = CaskLoader.tap_cask_token_type(ref, warn: warn)
        new("#{tap}/#{token}")
      end

      sig { params(token: String, from_json: Hash).void }
      def initialize(token, from_json: T.unsafe(nil))
        @token = token.sub(%r{^homebrew/(?:homebrew-)?cask/}i, "")
        @path = CaskLoader.default_path(@token)
        @from_json = from_json
      end

      def load(config:)
        json_cask = from_json || Homebrew::API::Cask.all_casks.fetch(token)

        cask_options = {
          loaded_from_api: true,
          source:          JSON.pretty_generate(json_cask),
          config:          config,
          loader:          self,
        }

        json_cask = Homebrew::API.merge_variations(json_cask).deep_symbolize_keys.freeze

        cask_options[:tap] = Tap.fetch(json_cask[:tap]) if json_cask[:tap].to_s.include?("/")

        user_agent = json_cask.dig(:url_specs, :user_agent)
        json_cask[:url_specs][:user_agent] = user_agent[1..].to_sym if user_agent && user_agent[0] == ":"
        if (using = json_cask.dig(:url_specs, :using))
          json_cask[:url_specs][:using] = using.to_sym
        end

        api_cask = Cask.new(token, **cask_options) do
          version json_cask[:version]

          if json_cask[:sha256] == "no_check"
            sha256 :no_check
          else
            sha256 json_cask[:sha256]
          end

          url json_cask[:url], **json_cask.fetch(:url_specs, {}) if json_cask[:url].present?
          appcast json_cask[:appcast] if json_cask[:appcast].present?
          json_cask[:name]&.each do |cask_name|
            name cask_name
          end
          desc json_cask[:desc]
          homepage json_cask[:homepage]

          if (deprecation_date = json_cask[:deprecation_date].presence)
            reason = DeprecateDisable.to_reason_string_or_symbol json_cask[:deprecation_reason], type: :cask
            deprecate! date: deprecation_date, because: reason
          end

          if (disable_date = json_cask[:disable_date].presence)
            reason = DeprecateDisable.to_reason_string_or_symbol json_cask[:disable_reason], type: :cask
            disable! date: disable_date, because: reason
          end

          auto_updates json_cask[:auto_updates] unless json_cask[:auto_updates].nil?
          conflicts_with(**json_cask[:conflicts_with]) if json_cask[:conflicts_with].present?

          if json_cask[:depends_on].present?
            dep_hash = json_cask[:depends_on].to_h do |dep_key, dep_value|
              # Arch dependencies are encoded like `{ type: :intel, bits: 64 }`
              # but `depends_on arch:` only accepts `:intel` or `:arm64`
              if dep_key == :arch
                next [:arch, :intel] if dep_value.first[:type] == "intel"

                next [:arch, :arm64]
              end

              next [dep_key, dep_value] if dep_key != :macos

              dep_type = dep_value.keys.first
              if dep_type == :==
                version_symbols = dep_value[dep_type].map do |version|
                  MacOSVersion::SYMBOLS.key(version) || version
                end
                next [dep_key, version_symbols]
              end

              version_symbol = dep_value[dep_type].first
              version_symbol = MacOSVersion::SYMBOLS.key(version_symbol) || version_symbol
              [dep_key, "#{dep_type} :#{version_symbol}"]
            end.compact
            depends_on(**dep_hash)
          end

          if json_cask[:container].present?
            container_hash = json_cask[:container].to_h do |container_key, container_value|
              next [container_key, container_value] if container_key != :type

              [container_key, container_value.to_sym]
            end
            container(**container_hash)
          end

          json_cask[:artifacts].each do |artifact|
            # convert generic string replacements into actual ones
            artifact = cask.loader.from_h_gsubs(artifact, appdir)
            key = artifact.keys.first
            if artifact[key].nil?
              # for artifacts with blocks that can't be loaded from the API
              send(key) {} # empty on purpose
            else
              args = artifact[key]
              kwargs = if args.last.is_a?(Hash)
                args.pop
              else
                {}
              end
              send(key, *args, **kwargs)
            end
          end

          if json_cask[:caveats].present?
            # convert generic string replacements into actual ones
            caveats cask.loader.from_h_string_gsubs(json_cask[:caveats], appdir)
          end
        end
        api_cask.populate_from_api!(json_cask)
        api_cask
      end

      def from_h_string_gsubs(string, appdir)
        string.to_s
              .gsub(HOMEBREW_HOME_PLACEHOLDER, Dir.home)
              .gsub(HOMEBREW_PREFIX_PLACEHOLDER, HOMEBREW_PREFIX)
              .gsub(HOMEBREW_CELLAR_PLACEHOLDER, HOMEBREW_CELLAR)
              .gsub(HOMEBREW_CASK_APPDIR_PLACEHOLDER, appdir)
      end

      def from_h_array_gsubs(array, appdir)
        array.to_a.map do |value|
          from_h_gsubs(value, appdir)
        end
      end

      def from_h_hash_gsubs(hash, appdir)
        hash.to_h.transform_values do |value|
          from_h_gsubs(value, appdir)
        end
      end

      def from_h_gsubs(value, appdir)
        return value if value.blank?

        case value
        when Hash
          from_h_hash_gsubs(value, appdir)
        when Array
          from_h_array_gsubs(value, appdir)
        when String
          from_h_string_gsubs(value, appdir)
        else
          value
        end
      end
    end

    # Loader which tries loading casks from tap paths, failing
    # if the same token exists in multiple taps.
    class FromAmbiguousTapPathLoader < FromPathLoader
      def self.try_new(ref, warn: false)
        case (possible_tap_casks = CaskLoader.tap_paths(ref)).count
        when 1
          new(possible_tap_casks.first)
        when 2..Float::INFINITY
          loaders = possible_tap_casks.map(&FromPathLoader.method(:new))
          raise TapCaskAmbiguityError.new(ref, loaders)
        end
      end
    end

    # Loader which loads a cask from the installed cask file.
    class FromInstalledPathLoader < FromPathLoader
      def self.try_new(ref, warn: false)
        possible_installed_cask = Cask.new(ref)
        return unless (installed_caskfile = possible_installed_cask.installed_caskfile)

        new(installed_caskfile)
      end
    end

    # Pseudo-loader which raises an error when trying to load the corresponding cask.
    class NullLoader < FromPathLoader
      sig {
        params(ref: T.any(String, Pathname, Cask, URI::Generic), warn: T::Boolean)
          .returns(T.nilable(T.attached_class))
      }
      def self.try_new(ref, warn: false)
        return if ref.is_a?(Cask)
        return if ref.is_a?(URI::Generic)

        new(ref)
      end

      sig { params(ref: T.any(String, Pathname)).void }
      def initialize(ref)
        token = File.basename(ref, ".rb")
        super CaskLoader.default_path(token)
      end

      def load(config:)
        raise CaskUnavailableError.new(token, "No Cask with this name exists.")
      end
    end

    def self.path(ref)
      self.for(ref, need_path: true).path
    end

    def self.load(ref, config: nil, warn: true)
      self.for(ref, warn: warn).load(config: config)
    end

    def self.tap_cask_token_type(tapped_token, warn:)
      user, repo, token = tapped_token.split("/", 3).map(&:downcase)
      tap = Tap.fetch(user, repo)
      type = nil

      if (new_token = tap.cask_renames[token].presence)
        old_token = token
        token = new_token
        new_token = tap.core_cask_tap? ? token : "#{tap}/#{token}"
        type = :rename
      elsif (new_tap_name = tap.tap_migrations[token].presence)
        new_tap_user, new_tap_repo, = new_tap_name.split("/")
        new_tap_name = "#{new_tap_user}/#{new_tap_repo}"
        new_tap = Tap.fetch(new_tap_name)
        new_tap.ensure_installed!
        new_tapped_token = "#{new_tap_name}/#{token}"
        token, tap, = tap_cask_token_type(new_tapped_token, warn: false)
        old_token = tapped_token
        new_token = new_tap.core_cask_tap? ? token : new_tapped_token
        type = :migration
      end

      opoo "Cask #{old_token} was renamed to #{new_token}." if warn && old_token && new_token

      [token, tap, type]
    end

    def self.for(ref, need_path: false, warn: true)
      [
        FromInstanceLoader,
        FromContentLoader,
        FromURILoader,
        FromAPILoader,
        FromTapLoader,
        FromPathLoader,
        FromDefaultTapPathLoader,
        FromAmbiguousTapPathLoader,
        FromDefaultTapLoader,
        FromInstalledPathLoader,
        NullLoader,
      ].each do |loader_class|
        if (loader = loader_class.try_new(ref, warn: warn))
          $stderr.puts "#{$PROGRAM_NAME} (#{loader.class}): loading #{ref}" if debug?
          return loader
        end
      end
    end

    def self.default_path(token)
      find_cask_in_tap(token.to_s.downcase, CoreCaskTap.instance)
    end

    def self.tap_paths(token)
      token = token.to_s.downcase

      Tap.map { |tap| find_cask_in_tap(token, tap) }.select(&:exist?)
    end

    def self.find_cask_in_tap(token, tap)
      filename = "#{token}.rb"

      Tap.cask_files_by_name(tap)
         .fetch(token, tap.cask_dir/filename)
    end
  end
end
