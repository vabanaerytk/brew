require "tap"

module Homebrew
  def tap
    if ARGV.empty?
      puts Tap.names
    elsif ARGV.first == "--repair"
      migrate_taps :force => true
    elsif ARGV.first == "--list-official"
      require "official_taps"
      puts OFFICIAL_TAPS.map { |t| "homebrew/#{t}" }
    elsif ARGV.first == "--list-pinned"
      puts Tap.select(&:pinned?).map(&:name)
    else
      user, repo = tap_args
      tap = Tap.fetch(user, repo)
      unless tap.installed?
        tap.install(:clone_target => ARGV.named[1],
                    :full_clone   => ARGV.include?("--full"))
      end
    end
  end

  # @deprecated this method will be removed in the future, if no external commands use it.
  def install_tap(user, repo, clone_target = nil)
    opoo "Homebrew.install_tap is deprecated, use Tap#install."
    tap = Tap.fetch(user, repo)
    begin
      tap.install(:clone_target => clone_target, :full_clone => ARGV.include?("--full"))
    rescue TapAlreadyTappedError
      false
    else
      true
    end
  end

  # Migrate tapped formulae from symlink-based to directory-based structure.
  def migrate_taps(options = {})
    ignore = HOMEBREW_LIBRARY/"Formula/.gitignore"
    return unless ignore.exist? || options.fetch(:force, false)
    (HOMEBREW_LIBRARY/"Formula").children.each { |c| c.unlink if c.symlink? }
    ignore.unlink if ignore.exist?
  end

  private

  def tap_args(tap_name = ARGV.named.first)
    tap_name =~ HOMEBREW_TAP_ARGS_REGEX
    raise "Invalid tap name" unless $1 && $3
    [$1, $3]
  end
end
