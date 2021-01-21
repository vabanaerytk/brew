# typed: ignore
# frozen_string_literal: true

# TODO: make this `typed: true` when HOMEBREW_BOOTSNAP is enabled by
# default and/or we vendor bootsnap and the RBI file.

raise "Needs HOMEBREW_BOOTSNAP!" unless ENV["HOMEBREW_BOOTSNAP"]

require "rubygems"

begin
  require "bootsnap"
rescue LoadError
  raise if ENV["HOMEBREW_BOOTSNAP_RETRY"]

  Dir.chdir(HOMEBREW_LIBRARY_PATH) do
    system "bundle", "install", "--standalone"
  end

  ENV["HOMEBREW_BOOTSNAP_RETRY"] = "1"
  exec ENV["HOMEBREW_BREW_FILE"], *ARGV
end

ENV.delete("HOMEBREW_BOOTSNAP_RETRY")

Bootsnap.setup(
  cache_dir:            "#{ENV["HOMEBREW_TEMP"]}/homebrew-bootsnap",
  development_mode:     false, # TODO: use ENV["HOMEBREW_DEVELOPER"]?,
  load_path_cache:      true,
  autoload_paths_cache: true,
  disable_trace:        true,
  compile_cache_iseq:   true,
  compile_cache_yaml:   true,
)
