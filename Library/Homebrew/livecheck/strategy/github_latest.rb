# typed: true
# frozen_string_literal: true

module Homebrew
  module Livecheck
    module Strategy
      # The {GithubLatest} strategy identifies versions of software at
      # github.com by checking a repository's "latest" release page.
      #
      # GitHub URLs take a few different formats:
      #
      # * `https://github.com/example/example/releases/download/1.2.3/example-1.2.3.tar.gz`
      # * `https://github.com/example/example/archive/v1.2.3.tar.gz`
      # * `https://github.com/downloads/example/example/example-1.2.3.tar.gz`
      #
      # A repository's `/releases/latest` URL normally redirects to a release
      # tag (e.g., `/releases/tag/1.2.3`). When there isn't a "latest" release,
      # it will redirect to the `/releases` page.
      #
      # This strategy should only be used when we know the upstream repository
      # has a "latest" release and the tagged release is appropriate to use
      # (e.g., "latest" isn't wrongly pointing to an unstable version, not
      # picking up the actual latest version, etc.). The strategy can only be
      # applied by using `strategy :github_latest` in a `livecheck` block.
      #
      # The default regex identifies versions like `1.2.3`/`v1.2.3` in `href`
      # attributes containing the tag URL (e.g.,
      # `/example/example/releases/tag/v1.2.3`). This is a common tag format
      # but a modified regex can be provided in a `livecheck` block to override
      # the default if a repository uses a different format (e.g.,
      # `example-1.2.3`, `1.2.3d`, `1.2.3-4`, etc.).
      #
      # @api public
      class GithubLatest
        NICE_NAME = "GitHub - Latest"

        # A priority of zero causes livecheck to skip the strategy. We do this
        # for {GithubLatest} so we can selectively apply the strategy using
        # `strategy :github_latest` in a `livecheck` block.
        PRIORITY = 0

        # The `Regexp` used to determine if the strategy applies to the URL.
        URL_MATCH_REGEX = %r{
          ^https?://github\.com
          /(?:downloads/)?(?<username>[^/]+) # The GitHub username
          /(?<repository>[^/]+)              # The GitHub repository name
        }ix.freeze

        # The default regex used to identify a version from a tag when a regex
        # isn't provided.
        DEFAULT_REGEX = /v?(\d+(?:\.\d+)+)/i.freeze

        # Keys in the JSON that could contain the version.
        VERSION_KEYS = ["name", "tag_name"].freeze

        # Whether the strategy can be applied to the provided URL.
        #
        # @param url [String] the URL to match against
        # @return [Boolean]
        sig { params(url: String).returns(T::Boolean) }
        def self.match?(url)
          URL_MATCH_REGEX.match?(url)
        end

        # Extracts information from a provided URL and uses it to generate
        # various input values used by the strategy to check for new versions.
        # Some of these values act as defaults and can be overridden in a
        # `livecheck` block.
        #
        # @param url [String] the URL used to generate values
        # @return [Hash]
        sig { params(url: String).returns(T::Hash[Symbol, T.untyped]) }
        def self.generate_input_values(url)
          values = {}

          match = url.sub(/\.git$/i, "").match(URL_MATCH_REGEX)
          return values if match.blank?

          values[:url] = "https://api.github.com/repos/#{match[:username]}/#{match[:repository]}/releases/latest"
          values[:username] = match[:username]
          values[:repository] = match[:repository]

          values
        end

        # Uses the regex to match release information in content or, if a block is
        # provided, passes the page content to the block to handle matching.
        # With either approach, an array of unique matches is returned.
        #
        # @param content [Array] list of releases
        # @param regex [Regexp] a regex used for matching versions in the content
        # @param block [Proc, nil] a block to match the content
        # @return [Array]
        sig {
          params(
            content: T::Array[T::Hash[String, T.untyped]],
            regex:   Regexp,
            block:   T.nilable(Proc),
          ).returns(T::Array[String])
        }
        def self.versions_from_content(content, regex, &block)
          if block.present?
            block_return_value = if regex.present?
              yield(content, regex)
            else
              yield(content)
            end
            return Strategy.handle_block_return(block_return_value)
          end

          content.reject(&:blank?).map do |release|
            next if release["draft"] || release["prerelease"]

            value = T.let(nil, T.untyped)
            VERSION_KEYS.find do |key|
              value = release[key]&.match(regex)&.to_s
            end
            value
          end.compact.uniq
        end

        # Generates a URL and regex (if one isn't provided) and passes them
        # to {PageMatch.find_versions} to identify versions in the content.
        #
        # @param url [String] the URL of the content to check
        # @param regex [Regexp] a regex used for matching versions in content
        # @return [Hash]
        sig {
          params(
            url:     String,
            regex:   Regexp,
            _unused: T.nilable(T::Hash[Symbol, T.untyped]),
            block:   T.nilable(Proc),
          ).returns(T::Hash[Symbol, T.untyped])
        }
        def self.find_versions(url:, regex: DEFAULT_REGEX, **_unused, &block)
          match_data = { matches: {}, regex: regex }
          generated = generate_input_values(url)
          return match_data if generated.blank?

          release = GitHub.get_latest_release(generated[:username], generated[:repository])
          versions_from_content([release], regex, &block).each do |match_text|
            match_data[:matches][match_text] = Version.new(match_text)
          end

          match_data
        end
      end
    end
    GitHubLatest = Homebrew::Livecheck::Strategy::GithubLatest
  end
end
