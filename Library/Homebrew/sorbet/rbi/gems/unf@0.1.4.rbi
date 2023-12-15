# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `unf` gem.
# Please instead update this file by running `bin/tapioca gem unf`.

# source://unf//lib/unf/version.rb#1
module UNF; end

# UTF-8 string normalizer class.  Implementations may vary depending
# on the platform.
#
# source://unf//lib/unf/normalizer.rb#10
class UNF::Normalizer
  include ::Singleton
  extend ::Singleton::SingletonClassMethods

  # @return [Normalizer] a new instance of Normalizer
  def initialize; end

  def normalize(_arg0, _arg1); end

  class << self
    def new(*_arg0); end

    # A shortcut for instance.normalize(string, form).
    #
    # source://unf//lib/unf/normalizer.rb#24
    def normalize(string, form); end

    private

    def allocate; end
  end
end

# source://unf//lib/unf/version.rb#2
UNF::VERSION = T.let(T.unsafe(nil), String)
