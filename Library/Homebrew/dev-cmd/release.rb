# typed: true
# frozen_string_literal: true

require "cli/parser"
require "release_notes"

module Homebrew
  extend T::Sig

  module_function

  sig { returns(CLI::Parser) }
  def release_args
    Homebrew::CLI::Parser.new do
      description <<~EOS
        Create a new draft Homebrew/brew release with the appropriate version number and release notes.

        By default, `brew release` will bump the patch version number. Pass
        `--major` or `--minor` to bump the major or minor version numbers, respectively.
        The command will fail if the previous major or minor release was made less than
        one month ago.

        Requires write access to the Homebrew/brew repository.
      EOS
      switch "--major",
             description: "Create a major release."
      switch "--minor",
             description: "Create a minor release."
      conflicts "--major", "--minor"

      named_args :none
    end
  end

  def release
    args = release_args.parse

    safe_system "git", "-C", HOMEBREW_REPOSITORY, "fetch", "origin" if Homebrew::EnvConfig.no_auto_update?

    begin
      latest_release = GitHub.get_latest_release "Homebrew", "brew"
    rescue GitHub::API::HTTPNotFoundError
      odie "No existing releases found!"
    end
    latest_version = Version.new latest_release["tag_name"]

    if args.major? || args.minor?
      one_month_ago = Date.today << 1
      latest_major_minor_release = begin
        GitHub.get_release "Homebrew", "brew", "#{latest_version.major_minor}.0"
      rescue GitHub::API::HTTPNotFoundError
        nil
      end

      if latest_major_minor_release.blank?
        opoo "Unable to determine the release date of the latest major/minor release."
      elsif Date.parse(latest_major_minor_release["published_at"]) > one_month_ago
        odie "The latest major/minor release was less than one month ago."
      end
    end

    new_version = if args.major?
      Version.new "#{latest_version.major.to_i + 1}.0.0"
    elsif args.minor?
      Version.new "#{latest_version.major}.#{latest_version.minor.to_i + 1}.0"
    else
      Version.new "#{latest_version.major}.#{latest_version.minor}.#{latest_version.patch.to_i + 1}"
    end.to_s

    if args.major? || args.minor?
      latest_major_minor_version = "#{latest_version.major}.#{latest_version.minor.to_i}.0"
      ohai "Release notes since #{latest_major_minor_version} for #{new_version} blog post:"
      # release notes without username suffix or dependabot bumps
      puts ReleaseNotes.generate_release_notes(latest_major_minor_version, "origin/HEAD", markdown: true)
                       .lines
                       .reject { |l| l.include?(" (@Homebrew)") }
                       .map { |l| l.gsub(/ \(@[\w-]+\)$/, "") }
                       .sort
    end

    ohai "Creating draft release for version #{new_version}"

    release_notes = if args.major? || args.minor?
      "Release notes for this release can be found on the [Homebrew blog](https://brew.sh/blog/#{new_version}).\n"
    else
      ""
    end
    release_notes += ReleaseNotes.generate_release_notes latest_version, "origin/HEAD", markdown: true

    begin
      release = GitHub.create_or_update_release "Homebrew", "brew", new_version, body: release_notes, draft: true
    rescue *GitHub::API::ERRORS => e
      odie "Unable to create release: #{e.message}!"
    end

    puts release["html_url"]
    exec_browser release["html_url"]
  end
end
