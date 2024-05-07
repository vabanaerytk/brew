# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::Cmd::Uses`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::Cmd::Uses`.


class Homebrew::Cmd::Uses
  sig { returns(Homebrew::Cmd::Uses::Args) }
  def args; end
end

class Homebrew::Cmd::Uses::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def cask?; end

  sig { returns(T::Boolean) }
  def casks?; end

  sig { returns(T::Boolean) }
  def eval_all?; end

  sig { returns(T::Boolean) }
  def formula?; end

  sig { returns(T::Boolean) }
  def formulae?; end

  sig { returns(T::Boolean) }
  def include_build?; end

  sig { returns(T::Boolean) }
  def include_optional?; end

  sig { returns(T::Boolean) }
  def include_test?; end

  sig { returns(T::Boolean) }
  def installed?; end

  sig { returns(T::Boolean) }
  def missing?; end

  sig { returns(T::Boolean) }
  def recursive?; end

  sig { returns(T::Boolean) }
  def skip_recommended?; end
end
