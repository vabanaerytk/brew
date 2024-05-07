# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::DevCmd::LivecheckCmd`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::DevCmd::LivecheckCmd`.


class Homebrew::DevCmd::LivecheckCmd
  sig { returns(Homebrew::DevCmd::LivecheckCmd::Args) }
  def args; end
end

class Homebrew::DevCmd::LivecheckCmd::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def cask?; end

  sig { returns(T::Boolean) }
  def casks?; end

  sig { returns(T::Boolean) }
  def eval_all?; end

  sig { returns(T::Boolean) }
  def extract_plist?; end

  sig { returns(T::Boolean) }
  def formula?; end

  sig { returns(T::Boolean) }
  def formulae?; end

  sig { returns(T::Boolean) }
  def full_name?; end

  sig { returns(T::Boolean) }
  def installed?; end

  sig { returns(T::Boolean) }
  def json?; end

  sig { returns(T::Boolean) }
  def newer_only?; end

  sig { returns(T::Boolean) }
  def r?; end

  sig { returns(T::Boolean) }
  def resources?; end

  sig { returns(T.nilable(String)) }
  def tap; end
end
