# typed: true
# frozen_string_literal: true

require "formula"
require "keg"
require "cli/parser"

module Homebrew
  extend T::Sig

  module_function

  sig { returns(CLI::Parser) }
  def switch_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `switch` <formula> <version>

        Symlink all of the specified <version> of <formula>'s installation into Homebrew's prefix.
      EOS

      named 2
      hide_from_man_page!
    end
  end

  def switch
    switch_args.parse

    odisabled "`brew switch`", "`brew link` @-versioned formulae"
  end
end
