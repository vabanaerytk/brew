class String
  def undent
    gsub(/^.{#{(slice(/^ +/) || '').length}}/, '')
  end

  # eg:
  #   if foo then <<-EOS.undent_________________________________________________________72
  #               Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
  #               eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
  #               minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip
  #               ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
  #               voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur
  #               sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt
  #               mollit anim id est laborum.
  #               EOS
  alias_method :undent_________________________________________________________72, :undent

  def start_with?(*prefixes)
    prefixes.any? do |prefix|
      if prefix.respond_to?(:to_str)
        prefix = prefix.to_str
        self[0, prefix.length] == prefix
      end
    end
  end unless method_defined?(:start_with?)

  def end_with?(*suffixes)
    suffixes.any? do |suffix|
      if suffix.respond_to?(:to_str)
        suffix = suffix.to_str
        self[-suffix.length, suffix.length] == suffix
      end
    end
  end unless method_defined?(:end_with?)

  # 1.8.7 or later; used in bottle code
  def rpartition(separator)
    if ind = rindex(separator)
      [slice(0, ind), separator, slice(ind+1, -1) || '']
    else
      ['', '', dup]
    end
  end unless method_defined?(:rpartition)

  # String.chomp, but if result is empty: returns nil instead.
  # Allows `chuzzle || foo` short-circuits.
  def chuzzle
    s = chomp
    s unless s.empty?
  end
end

class NilClass
  def chuzzle; end
end

# used by the inreplace function (in utils.rb)
module StringInreplaceExtension
  def sub! before, after
    result = super
    unless result
      opoo "inreplace: replacement of '#{before}' with '#{after}' failed"
    end
    result
  end

  # Warn if nothing was replaced
  def gsub! before, after, audit_result=true
    result = super(before, after)
    if audit_result && result.nil?
      opoo "inreplace: replacement of '#{before}' with '#{after}' failed"
    end
    result
  end

  # Looks for Makefile style variable defintions and replaces the
  # value with "new_value", or removes the definition entirely.
  def change_make_var! flag, new_value
    new_value = "#{flag}=#{new_value}"
    unless gsub!(/^#{Regexp.escape(flag)}[ \t]*=[ \t]*(.*)$/, new_value, false)
      opoo "inreplace: changing '#{flag}' to '#{new_value}' failed"
    end
  end

  # Removes variable assignments completely.
  def remove_make_var! flags
    Array(flags).each do |flag|
      # Also remove trailing \n, if present.
      unless gsub!(/^#{Regexp.escape(flag)}[ \t]*=.*$\n?/, "", false)
        opoo "inreplace: removing '#{flag}' failed"
      end
    end
  end

  # Finds the specified variable
  def get_make_var flag
    self[/^#{Regexp.escape(flag)}[ \t]*=[ \t]*(.*)$/, 1]
  end
end
