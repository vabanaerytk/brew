# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::DevCmd::Rubydoc`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::DevCmd::Rubydoc`.

class Homebrew::DevCmd::Rubydoc
  sig { returns(Homebrew::DevCmd::Rubydoc::Args) }
  def args; end
end

class Homebrew::DevCmd::Rubydoc::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def only_public?; end

  sig { returns(T::Boolean) }
  def open?; end
end
