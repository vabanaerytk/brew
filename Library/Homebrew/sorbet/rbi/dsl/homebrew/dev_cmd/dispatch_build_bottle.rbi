# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::DevCmd::DispatchBuildBottle`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::DevCmd::DispatchBuildBottle`.

class Homebrew::CLI::Args
  sig { returns(T.nilable(String)) }
  def issue; end

  sig { returns(T::Boolean) }
  def linux?; end

  sig { returns(T::Boolean) }
  def linux_self_hosted?; end

  sig { returns(T::Boolean) }
  def linux_wheezy?; end

  sig { returns(T.nilable(T::Array[String])) }
  def macos; end

  sig { returns(T.nilable(String)) }
  def tap; end

  sig { returns(T.nilable(String)) }
  def timeout; end

  sig { returns(T::Boolean) }
  def upload?; end

  sig { returns(T.nilable(String)) }
  def workflow; end
end
