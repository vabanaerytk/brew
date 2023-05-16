# typed: true
# frozen_string_literal: true

module Homebrew
  module Livecheck
    module Strategy
      # The {GithubRelease} strategy identifies versions of software at
      # github.com by checking a repository's recent releases using the
      # GitHub API.
      #
      # GitHub URLs take a few different formats:
      #
      # * `https://github.com/example/example/releases/download/1.2.3/example-1.2.3.tar.gz`
      # * `https://github.com/example/example/archive/v1.2.3.tar.gz`
      # * `https://github.com/downloads/example/example/example-1.2.3.tar.gz`
      #
      # {GithubRelease} should only be used when the upstream repository has
      # releases for suitable versions and the strategy is necessary or
      # appropriate (e.g. the formula/cask uses a release asset and the
      # {GithubLatest} strategy isn't sufficient to identify the newest version.
      # The strategy can only be applied by using `strategy :github_release`
      # in a `livecheck` block.
      #
      # The default regex identifies versions like `1.2.3`/`v1.2.3` in each
      # release's tag or title. This is a common tag format but a modified
      # regex can be provided in a `livecheck` block to override the default
      # if a repository uses a different format (e.g. `1.2.3d`, `1.2.3-4`,
      # etc.).
      #
      # @api public
      class GithubRelease
        NICE_NAME = "GitHub - Releases"

        # A priority of zero causes livecheck to skip the strategy. We do this
        # for {GithubRelease} so we can selectively apply the strategy using
        # `strategy :github_release` in a `livecheck` block.
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

        # Keys in the release JSON that could contain the version.
        # The tag name is checked first, to better align with the {Git}
        # strategy.
        VERSION_KEYS = ["tag_name", "name"].freeze

        # Whether the strategy can be applied to the provided URL.
        #
        # @param url [String] the URL to match against
        # @return [Boolean]
        sig { params(url: String).returns(T::Boolean) }
        def self.match?(url)
          URL_MATCH_REGEX.match?(url)
        end

        # Uses a regex to match versions from release JSON or, if a block is
        # provided, passes the JSON to the block to handle matching. With
        # either approach, an array of unique matches is returned.
        #
        # @param content [Array, Hash] array of releases or a single release
        # @param regex [Regexp] a regex used for matching versions in the
        # content
        # @param block [Proc, nil] a block to match the content
        # @return [Array]
        sig {
          params(
            content: T.any(T::Array[T::Hash[String, T.untyped]], T::Hash[String, T.untyped]),
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

          content = [content] unless content.is_a?(Array)
          content.reject(&:blank?).map do |release|
            next if release["draft"] || release["prerelease"]

            value = T.let(nil, T.untyped)
            VERSION_KEYS.find do |key|
              match = release[key]&.match(regex)
              next if match.blank?

              value = match[1]
            end
            value
          end.compact.uniq
        end

        # Generates the GitHub API URL for the repository's recent releases
        # and identifies versions from the JSON response.
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
          match = url.delete_suffix(".git")
                     .match(URL_MATCH_REGEX)
          return match_data if match.blank?

          releases = GitHub::API.open_rest("https://api.github.com/repos/#{match[:username]}/#{match[:repository]}/releases")
          versions_from_content(releases, regex, &block).each do |match_text|
            match_data[:matches][match_text] = Version.new(match_text)
          end

          match_data
        end
      end
    end
    GitHubRelease = Homebrew::Livecheck::Strategy::GithubRelease
  end
end
