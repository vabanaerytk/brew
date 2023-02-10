# typed: strict
# frozen_string_literal: true

module Utils
  module Analytics
    class << self
      extend T::Sig

      sig { params(verbose: T::Boolean).returns(String) }
      def custom_prefix_label(verbose: false)
        return generic_custom_prefix_label(verbose: verbose) if Hardware::CPU.arm?

        "non-/usr/local"
      end

      sig { params(verbose: T::Boolean).returns(String) }
      def arch_label(verbose: false)
        return "Rosetta" if Hardware::CPU.in_rosetta2?

        generic_arch_label(verbose: verbose)
      end
    end
  end
end
