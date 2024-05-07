# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::DevCmd::Audit`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::DevCmd::Audit`.


class Homebrew::DevCmd::Audit
  sig { returns(Homebrew::DevCmd::Audit::Args) }
  def args; end
end

class Homebrew::DevCmd::Audit::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def D?; end

  sig { returns(T.nilable(String)) }
  def arch; end

  sig { returns(T::Boolean) }
  def audit_debug?; end

  sig { returns(T::Boolean) }
  def cask?; end

  sig { returns(T::Boolean) }
  def casks?; end

  sig { returns(T::Boolean) }
  def display_cop_names?; end

  sig { returns(T::Boolean) }
  def display_filename?; end

  sig { returns(T::Boolean) }
  def eval_all?; end

  sig { returns(T.nilable(T::Array[String])) }
  def except; end

  sig { returns(T.nilable(T::Array[String])) }
  def except_cops; end

  sig { returns(T::Boolean) }
  def fix?; end

  sig { returns(T::Boolean) }
  def formula?; end

  sig { returns(T::Boolean) }
  def formulae?; end

  sig { returns(T::Boolean) }
  def git?; end

  sig { returns(T::Boolean) }
  def installed?; end

  sig { returns(T::Boolean) }
  def new?; end

  sig { returns(T::Boolean) }
  def online?; end

  sig { returns(T.nilable(T::Array[String])) }
  def only; end

  sig { returns(T.nilable(T::Array[String])) }
  def only_cops; end

  sig { returns(T.nilable(String)) }
  def os; end

  sig { returns(T.nilable(String)) }
  def signing?; end

  sig { returns(T::Boolean) }
  def skip_style?; end

  sig { returns(T::Boolean) }
  def strict?; end

  sig { returns(T.nilable(String)) }
  def tap; end

  sig { returns(T::Boolean) }
  def token_conflicts?; end
end
