# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `netrc` gem.
# Please instead update this file by running `bin/tapioca gem netrc`.

# source://netrc//lib/netrc.rb#3
class Netrc
  # @return [Netrc] a new instance of Netrc
  #
  # source://netrc//lib/netrc.rb#166
  def initialize(path, data); end

  # source://netrc//lib/netrc.rb#180
  def [](k); end

  # source://netrc//lib/netrc.rb#188
  def []=(k, info); end

  # source://netrc//lib/netrc.rb#200
  def delete(key); end

  # source://netrc//lib/netrc.rb#211
  def each(&block); end

  # source://netrc//lib/netrc.rb#196
  def length; end

  # source://netrc//lib/netrc.rb#215
  def new_item(m, l, p); end

  # Returns the value of attribute new_item_prefix.
  #
  # source://netrc//lib/netrc.rb#178
  def new_item_prefix; end

  # Sets the attribute new_item_prefix
  #
  # @param value the value to set the attribute new_item_prefix to.
  #
  # source://netrc//lib/netrc.rb#178
  def new_item_prefix=(_arg0); end

  # source://netrc//lib/netrc.rb#219
  def save; end

  # source://netrc//lib/netrc.rb#233
  def unparse; end

  class << self
    # source://netrc//lib/netrc.rb#42
    def check_permissions(path); end

    # source://netrc//lib/netrc.rb#33
    def config; end

    # @yield [self.config]
    #
    # source://netrc//lib/netrc.rb#37
    def configure; end

    # source://netrc//lib/netrc.rb#10
    def default_path; end

    # source://netrc//lib/netrc.rb#14
    def home_path; end

    # source://netrc//lib/netrc.rb#85
    def lex(lines); end

    # source://netrc//lib/netrc.rb#29
    def netrc_filename; end

    # Returns two values, a header and a list of items.
    # Each item is a tuple, containing some or all of:
    # - machine keyword (including trailing whitespace+comments)
    # - machine name
    # - login keyword (including surrounding whitespace+comments)
    # - login
    # - password keyword (including surrounding whitespace+comments)
    # - password
    # - trailing chars
    # This lets us change individual fields, then write out the file
    # with all its original formatting.
    #
    # source://netrc//lib/netrc.rb#129
    def parse(ts); end

    # Reads path and parses it as a .netrc file. If path doesn't
    # exist, returns an empty object. Decrypt paths ending in .gpg.
    #
    # source://netrc//lib/netrc.rb#51
    def read(path = T.unsafe(nil)); end

    # @return [Boolean]
    #
    # source://netrc//lib/netrc.rb#112
    def skip?(s); end
  end
end

# source://netrc//lib/netrc.rb#8
Netrc::CYGWIN = T.let(T.unsafe(nil), T.untyped)

# source://netrc//lib/netrc.rb#244
class Netrc::Entry < ::Struct
  # Returns the value of attribute login
  #
  # @return [Object] the current value of login
  def login; end

  # Sets the attribute login
  #
  # @param value [Object] the value to set the attribute login to.
  # @return [Object] the newly set value
  def login=(_); end

  # Returns the value of attribute password
  #
  # @return [Object] the current value of password
  def password; end

  # Sets the attribute password
  #
  # @param value [Object] the value to set the attribute password to.
  # @return [Object] the newly set value
  def password=(_); end

  def to_ary; end

  class << self
    def [](*_arg0); end
    def inspect; end
    def keyword_init?; end
    def members; end
    def new(*_arg0); end
  end
end

# source://netrc//lib/netrc.rb#250
class Netrc::Error < ::StandardError; end

# source://netrc//lib/netrc.rb#68
class Netrc::TokenArray < ::Array
  # source://netrc//lib/netrc.rb#76
  def readto; end

  # source://netrc//lib/netrc.rb#69
  def take; end
end

# source://netrc//lib/netrc.rb#4
Netrc::VERSION = T.let(T.unsafe(nil), String)

# see http://stackoverflow.com/questions/4871309/what-is-the-correct-way-to-detect-if-ruby-is-running-on-windows
#
# source://netrc//lib/netrc.rb#7
Netrc::WINDOWS = T.let(T.unsafe(nil), T.untyped)
