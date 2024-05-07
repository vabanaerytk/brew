# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::DevCmd::Edit`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::DevCmd::Edit`.


class Homebrew::DevCmd::Edit
  sig { returns(Homebrew::DevCmd::Edit::Args) }
  def args; end
end

class Homebrew::DevCmd::Edit::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def cask?; end

  sig { returns(T::Boolean) }
  def casks?; end

  sig { returns(T::Boolean) }
  def formula?; end

  sig { returns(T::Boolean) }
  def formulae?; end

  sig { returns(T::Boolean) }
  def print_path?; end
end
