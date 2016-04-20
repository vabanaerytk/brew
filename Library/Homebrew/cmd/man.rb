require "formula"
require "erb"
require "ostruct"

module Homebrew
  SOURCE_PATH = HOMEBREW_LIBRARY_PATH/"manpages"
  TARGET_MAN_PATH = HOMEBREW_REPOSITORY/"share/man/man1"
  TARGET_DOC_PATH = HOMEBREW_REPOSITORY/"share/doc/homebrew"

  def man
    raise UsageError unless ARGV.named.empty?

    if ARGV.flag? "--link"
      link_man_pages
    else
      regenerate_man_pages
    end
  end

  private

  def link_man_pages
    linked_path = HOMEBREW_PREFIX/"share/man/man1"

    if TARGET_MAN_PATH == linked_path
      odie "The target path is the same as the linked one."
    end

    Dir["#{TARGET_MAN_PATH}/*.1"].each do |page|
      FileUtils.ln_s page, linked_path
    end
  end

  def regenerate_man_pages
    Homebrew.install_gem_setup_path! "ronn"

    markup = build_man_page
    convert_man_page(markup, TARGET_DOC_PATH/"brew.1.html")
    convert_man_page(markup, TARGET_MAN_PATH/"brew.1")
  end

  def build_man_page
    template = (SOURCE_PATH/"brew.1.md.erb").read
    variables = OpenStruct.new

    variables[:commands] = Pathname.glob("#{HOMEBREW_LIBRARY_PATH}/cmd/*.{rb,sh}").
      sort_by { |source_file| sort_key_for_path(source_file) }.
      map { |source_file|
        source_file.read.lines.
          grep(/^#:/).
          map { |line| line.slice(2..-1) }.
          join
      }.
      reject { |s| s.strip.empty? }

    ERB.new(template, nil, ">").result(variables.instance_eval{ binding })
  end

  def sort_key_for_path(path)
    # Options after regular commands (`~` comes after `z` in ASCII table).
    path.basename.to_s.sub(/\.(rb|sh)$/, "").sub(/^--/, "~~")
  end

  def convert_man_page(markup, target)
    shared_args = %W[
      --pipe
      --organization=Homebrew
      --manual=brew
    ]

    format_flag, format_desc = target_path_to_format(target)

    puts "Writing #{format_desc} to #{target}"
    Utils.popen(["ronn", format_flag] + shared_args, "rb+") do |ronn|
      ronn.write markup
      ronn.close_write
      target.atomic_write ronn.read
    end
  end

  def target_path_to_format(target)
    case target.basename
    when /\.html?$/ then ["--fragment", "HTML fragment"]
    when /\.\d$/    then ["--roff", "man page"]
    else
      odie "Failed to infer output format from '#{target.basename}'."
    end
  end
end
