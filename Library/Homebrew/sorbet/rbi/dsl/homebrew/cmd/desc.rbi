# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::Cmd::Desc`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::Cmd::Desc`.

class Homebrew::Cmd::Desc
  sig { returns(Homebrew::Cmd::Desc::Args) }
  def args; end
end

class Homebrew::Cmd::Desc::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def cask?; end

  sig { returns(T::Boolean) }
  def casks?; end

  sig { returns(T::Boolean) }
  def description?; end

  sig { returns(T::Boolean) }
  def eval_all?; end

  sig { returns(T::Boolean) }
  def formula?; end

  sig { returns(T::Boolean) }
  def formulae?; end

  sig { returns(T::Boolean) }
  def n?; end

  sig { returns(T::Boolean) }
  def name?; end

  sig { returns(T::Boolean) }
  def s?; end

  sig { returns(T::Boolean) }
  def search?; end
end
