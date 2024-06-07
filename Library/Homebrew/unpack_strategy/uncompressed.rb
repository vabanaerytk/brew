# typed: true
# frozen_string_literal: true

require "utils/cp"

module UnpackStrategy
  # Strategy for unpacking uncompressed files.
  class Uncompressed
    include UnpackStrategy

    sig {
      params(
        to:                   T.nilable(Pathname),
        basename:             T.nilable(T.any(String, Pathname)),
        verbose:              T::Boolean,
        prioritize_extension: T::Boolean,
      ).returns(T.untyped)
    }
    def extract_nestedly(to: nil, basename: nil, verbose: false, prioritize_extension: false)
      extract(to:, basename:, verbose:)
    end

    private

    sig { override.params(unpack_dir: Pathname, basename: Pathname, verbose: T::Boolean).returns(T.untyped) }
    def extract_to_dir(unpack_dir, basename:, verbose: false)
      Utils::Cp.with_attributes path, unpack_dir/basename.sub(/^[\da-f]{64}--/, ""), verbose:
    end
  end
end
