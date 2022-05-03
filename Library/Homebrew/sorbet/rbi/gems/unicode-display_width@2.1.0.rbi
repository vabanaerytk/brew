# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `unicode-display_width` gem.
# Please instead update this file by running `bin/tapioca gem unicode-display_width`.

module Unicode; end

class Unicode::DisplayWidth
  def initialize(ambiguous: T.unsafe(nil), overwrite: T.unsafe(nil), emoji: T.unsafe(nil)); end

  def get_config(**kwargs); end
  def of(string, **kwargs); end

  class << self
    def emoji_extra_width_of(string, ambiguous = T.unsafe(nil), overwrite = T.unsafe(nil), _ = T.unsafe(nil)); end
    def of(string, ambiguous = T.unsafe(nil), overwrite = T.unsafe(nil), options = T.unsafe(nil)); end
  end
end

Unicode::DisplayWidth::DATA_DIRECTORY = T.let(T.unsafe(nil), String)
Unicode::DisplayWidth::DEPTHS = T.let(T.unsafe(nil), Array)
Unicode::DisplayWidth::INDEX = T.let(T.unsafe(nil), Array)
Unicode::DisplayWidth::INDEX_FILENAME = T.let(T.unsafe(nil), String)
Unicode::DisplayWidth::UNICODE_VERSION = T.let(T.unsafe(nil), String)
Unicode::DisplayWidth::VERSION = T.let(T.unsafe(nil), String)
