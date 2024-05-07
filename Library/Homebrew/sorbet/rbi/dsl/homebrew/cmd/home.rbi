# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::Cmd::Home`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::Cmd::Home`.


class Homebrew::Cmd::Home
  sig { returns(Homebrew::Cmd::Home::Args) }
  def args; end
end

class Homebrew::Cmd::Home::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def cask?; end

  sig { returns(T::Boolean) }
  def casks?; end

  sig { returns(T::Boolean) }
  def formula?; end

  sig { returns(T::Boolean) }
  def formulae?; end
end
