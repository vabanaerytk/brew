# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::Cmd::UnlinkCmd`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::Cmd::UnlinkCmd`.

class Homebrew::Cmd::UnlinkCmd
  sig { returns(Homebrew::Cmd::UnlinkCmd::Args) }
  def args; end
end

class Homebrew::Cmd::UnlinkCmd::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def dry_run?; end

  sig { returns(T::Boolean) }
  def n?; end
end
