# frozen_string_literal: true

require "rubocops/rubocop-cask"

describe RuboCop::Cop::Cask::ArrayAlphabetization, :config do
  it "reports an offense when a single `zap trash` path is specified in an array" do
    expect_offense(<<~CASK)
      cask "foo" do
        url "https://example.com/foo.zip"

        zap trash: ["~/Library/Application Support/Foo"]
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Remove the `[]` around a single `zap trash` path
      end
    CASK

    expect_correction(<<~CASK)
      cask "foo" do
        url "https://example.com/foo.zip"

        zap trash: "~/Library/Application Support/Foo"
      end
    CASK
  end

  it "reports an offense when the `zap trash` paths are not in alphabetical order" do
    expect_offense(<<~CASK)
      cask "foo" do
        url "https://example.com/foo.zip"

        zap trash: [
          "/Library/Application Support/Foo",
          "/Library/Application Support/Baz",
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The `zap trash` paths should be in alphabetical order
          "~/Library/Application Support/Foo",
          "~/.dotfiles/thing",
          ^^^^^^^^^^^^^^^^^^^ The `zap trash` paths should be in alphabetical order
          "~/Library/Application Support/Bar",
        ]
      end
    CASK

    expect_correction(<<~CASK)
      cask "foo" do
        url "https://example.com/foo.zip"

        zap trash: [
          "/Library/Application Support/Baz",
          "/Library/Application Support/Foo",
          "~/.dotfiles/thing",
          "~/Library/Application Support/Bar",
          "~/Library/Application Support/Foo",
        ]
      end
    CASK
  end

  it "ignores zap trash paths that have interpolation" do
    expect_no_offenses(<<~CASK)
      cask "foo" do
        url "https://example.com/foo.zip"

        zap trash: [
          "~/Library/Application Support/Foo",
          "~/Library/Application Support/Bar\#{version.major}",
        ]
      end
    CASK
  end
end
