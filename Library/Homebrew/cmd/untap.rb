# typed: true
# frozen_string_literal: true

require "cli/parser"

module Homebrew
  extend T::Sig

  module_function

  sig { returns(CLI::Parser) }
  def untap_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `untap` <tap>

        Remove a tapped formula repository.
      EOS

      min_named 1
    end
  end

  def untap
    args = untap_args.parse

    args.named.each do |tapname|
      tap = Tap.fetch(tapname)
      odie "Untapping #{tap} is not allowed" if tap.core_tap?

      installed_tap_formulae = Formula.installed.select { |formula| formula.tap == tap }
      installed_tap_casks = Cask::Caskroom.casks.select { |cask| cask.tap == tap }

      if installed_tap_formulae.present? || installed_tap_casks.present?
        installed_names = (installed_tap_formulae + installed_tap_casks.map(&:token)).join("\n")
        if args.force? || Homebrew::EnvConfig.developer?
          opoo <<~EOS
            Untapping #{tap} even though it contains the following installed formulae or casks:
            #{installed_names}
          EOS
        else
          odie <<~EOS
            Refusing to untap #{tap} because it contains the following installed formulae or casks:
            #{installed_names}
          EOS
        end
      end

      tap.uninstall
    end
  end
end
