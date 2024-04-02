# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::Cmd::TapCmd`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::Cmd::TapCmd`.

class Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def custom_remote?; end

  sig { returns(T::Boolean) }
  def eval_all?; end

  sig { returns(T::Boolean) }
  def force?; end

  sig { returns(T.nilable(String)) }
  def force_auto_update?; end

  sig { returns(T::Boolean) }
  def repair?; end
end
