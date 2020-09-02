# frozen_string_literal: true

# Various helper functions for interacting with TTYs.
#
# @api private
module Tty
  @stream = $stdout

  module_function

  def with(stream)
    previous_stream = @stream
    @stream = stream

    yield stream
  ensure
    @stream = previous_stream
  end

  def strip_ansi(string)
    string.gsub(/\033\[\d+(;\d+)*m/, "")
  end

  def width
    @width ||= begin
      _, width = `/bin/stty size 2>/dev/null`.split
      width, = `/usr/bin/tput cols 2>/dev/null`.split if width.to_i.zero?
      width ||= 80
      width.to_i
    end
  end

  def truncate(string)
    (w = width).zero? ? string.to_s : string.to_s[0, w - 4]
  end

  COLOR_CODES = {
    red:     31,
    green:   32,
    yellow:  33,
    blue:    34,
    magenta: 35,
    cyan:    36,
    default: 39,
  }.freeze

  STYLE_CODES = {
    reset:         0,
    bold:          1,
    italic:        3,
    underline:     4,
    strikethrough: 9,
    no_underline:  24,
  }.freeze

  SPECIAL_CODES = {
    up:         "1A",
    down:       "1B",
    right:      "1C",
    left:       "1D",
    erase_line: "K",
    erase_char: "P",
  }.freeze

  CODES = COLOR_CODES.merge(STYLE_CODES).freeze

  def append_to_escape_sequence(code)
    @escape_sequence ||= []
    @escape_sequence << code
    self
  end

  def current_escape_sequence
    return "" if @escape_sequence.nil?

    "\033[#{@escape_sequence.join(";")}m"
  end

  def reset_escape_sequence!
    @escape_sequence = nil
  end

  CODES.each do |name, code|
    define_singleton_method(name) do
      append_to_escape_sequence(code)
    end
  end

  SPECIAL_CODES.each do |name, code|
    define_singleton_method(name) do
      if $stdout.tty?
        "\033[#{code}"
      else
        ""
      end
    end
  end

  def to_s
    return "" unless color?

    current_escape_sequence
  ensure
    reset_escape_sequence!
  end

  def color?
    return false if Homebrew::EnvConfig.no_color?
    return true if Homebrew::EnvConfig.color?

    @stream.tty?
  end
end
