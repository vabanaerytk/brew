# typed: false
# frozen_string_literal: true

require "rubocops/rubocop-cask"
require "test/rubocops/cask/shared_examples/cask_cop"

describe RuboCop::Cop::Cask::NoOverrides do
  include CaskCop

  subject(:cop) { described_class.new }

  context "when there are no top-level standalone stanzas" do
    let(:source) do
      <<~CASK
        cask 'foo' do
          on_mojave :or_later do
            version :latest
          end
        end
      CASK
    end

    include_examples "does not report any offenses"
  end

  context "when there are top-level standalone stanzas" do
    let(:source) do
      <<~CASK
        cask 'foo' do
          version '2.3.4'
          on_mojave :or_older do
            version '1.2.3'
          end

          url 'https://brew.sh/foo-2.3.4.dmg'
        end
      CASK
    end

    let(:expected_offenses) do
      [{
        message:  <<~EOS,
          Do not use top-level `version` stanza as the default, add an `on_{system}` block instead.
          Use `:or_older` or `:or_newer` to specify a range of macOS versions.
        EOS
        severity: :convention,
        line:     2,
        column:   2,
        source:   "version '2.3.4'",
      }, {
        message:  <<~EOS,
          Do not use top-level `url` stanza as the default, add an `on_{system}` block instead.
          Use `:or_older` or `:or_newer` to specify a range of macOS versions.
        EOS
        severity: :convention,
        line:     7,
        column:   2,
        source:   "url 'https://brew.sh/foo-2.3.4.dmg'",
      }]
    end

    include_examples "reports offenses"
  end
end
