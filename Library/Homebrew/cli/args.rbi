# typed: strict

# This file contains global args as defined in `Homebrew::CLI::Parser.global_options`
# `Command`-specific args are defined in the commands themselves, with type signatures
# generated by the `Tapioca::Compilers::Args` compiler.

class Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def debug?; end

  sig { returns(T::Boolean) }
  def help?; end

  sig { returns(T::Boolean) }
  def quiet?; end

  sig { returns(T::Boolean) }
  def verbose?; end
end
