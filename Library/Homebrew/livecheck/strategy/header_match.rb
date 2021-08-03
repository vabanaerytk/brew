# typed: false
# frozen_string_literal: true

require_relative "page_match"

module Homebrew
  module Livecheck
    module Strategy
      # The {HeaderMatch} strategy follows all URL redirections and scans
      # the resulting headers for matching text using the provided regex.
      #
      # @api private
      class HeaderMatch
        extend T::Sig

        NICE_NAME = "Header match"

        # A priority of zero causes livecheck to skip the strategy. We only
        # apply {HeaderMatch} using `strategy :header_match` in a `livecheck`
        # block, as we can't automatically determine when this can be
        # successfully applied to a URL.
        PRIORITY = 0

        # The `Regexp` used to determine if the strategy applies to the URL.
        URL_MATCH_REGEX = %r{^https?://}i.freeze

        # The header fields to check when a `strategy` block isn't provided.
        DEFAULT_HEADERS_TO_CHECK = ["content-disposition", "location"].freeze

        # Whether the strategy can be applied to the provided URL.
        # The strategy will technically match any HTTP URL but is
        # only usable with a `livecheck` block containing a regex
        # or block.
        sig { params(url: String).returns(T::Boolean) }
        def self.match?(url)
          URL_MATCH_REGEX.match?(url)
        end

        # Checks the final URL for new versions after following all redirections,
        # using the provided regex for matching.
        sig {
          params(
            url:   String,
            regex: T.nilable(Regexp),
            cask:  T.nilable(Cask::Cask),
            block: T.nilable(T.proc.params(arg0: T::Hash[String, String]).returns(T.nilable(String))),
          ).returns(T::Hash[Symbol, T.untyped])
        }
        def self.find_versions(url, regex, cask: nil, &block)
          match_data = { matches: {}, regex: regex, url: url }

          headers = Strategy.page_headers(url)

          # Merge the headers from all responses into one hash
          merged_headers = headers.reduce(&:merge)

          version = if block
            case (value = block.call(merged_headers, regex))
            when String
              value
            when nil
              return match_data
            else
              raise TypeError, "Return value of `strategy :header_match` block must be a string."
            end
          else
            value = nil
            DEFAULT_HEADERS_TO_CHECK.each do |header_name|
              header_value = merged_headers[header_name]
              next if header_value.blank?

              if regex
                value = header_value[regex, 1]
              else
                v = Version.parse(header_value, detected_from_url: true)
                value = v.to_s unless v.null?
              end
              break if value.present?
            end

            value
          end

          match_data[:matches][version] = Version.new(version) if version

          match_data
        end
      end
    end
  end
end
