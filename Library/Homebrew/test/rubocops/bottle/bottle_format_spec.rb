# typed: false
# frozen_string_literal: true

require "rubocops/bottle"

describe RuboCop::Cop::FormulaAudit::BottleFormat do
  subject(:cop) { described_class.new }

  it "reports no offenses for `bottle :uneeded`" do
    expect_no_offenses(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle :unneeded
      end
    RUBY
  end

  it "reports and corrects old `sha256` syntax in `bottle` block without cellars" do
    expect_offense(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          sha256 "faceb00c" => :big_sur
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `sha256` should use new syntax
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          sha256 big_sur: "faceb00c"
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          rebuild 4
          sha256 "faceb00c" => :big_sur
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `sha256` should use new syntax
          sha256 "deadbeef" => :catalina
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `sha256` should use new syntax
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          rebuild 4
          sha256 big_sur: "faceb00c"
          sha256 catalina: "deadbeef"
        end
      end
    RUBY
  end

  it "reports and corrects old `sha256` syntax in `bottle` block without cellars" do
    expect_offense(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          cellar :any
          ^^^^^^^^^^^ `cellar` should be a parameter to `sha256`
          rebuild 4
          sha256 "faceb00c" => :big_sur
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `sha256` should use new syntax
          sha256 "deadbeef" => :catalina
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `sha256` should use new syntax
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          rebuild 4
          sha256 cellar: :any, big_sur: "faceb00c"
          sha256 cellar: :any, catalina: "deadbeef"
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          cellar :any
          ^^^^^^^^^^^ `cellar` should be a parameter to `sha256`
          sha256 "faceb00c" => :big_sur
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `sha256` should use new syntax
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          sha256 cellar: :any, big_sur: "faceb00c"
        end
      end
    RUBY

    expect_offense(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          cellar "/usr/local/Cellar"
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ `cellar` should be a parameter to `sha256`
          rebuild 4
          sha256 "faceb00c" => :big_sur
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `sha256` should use new syntax
          sha256 "deadbeef" => :catalina
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `sha256` should use new syntax
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo < Formula
        url "https://brew.sh/foo-1.0.tgz"

        bottle do
          rebuild 4
          sha256 cellar: "/usr/local/Cellar", big_sur: "faceb00c"
          sha256 cellar: "/usr/local/Cellar", catalina: "deadbeef"
        end
      end
    RUBY
  end
end
