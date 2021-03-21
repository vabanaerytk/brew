# typed: false
# frozen_string_literal: true

require "cli/parser"
require "archive"
require "bintray"
require "github_packages"
require "github_releases"

module Homebrew
  extend T::Sig

  module_function

  sig { returns(CLI::Parser) }
  def pr_upload_args
    Homebrew::CLI::Parser.new do
      description <<~EOS
        Apply the bottle commit and publish bottles to a host.
      EOS
      switch "--no-publish",
             description: "Apply the bottle commit and upload the bottles, but don't publish them."
      switch "--keep-old",
             description: "If the formula specifies a rebuild version, " \
                          "attempt to preserve its value in the generated DSL."
      switch "-n", "--dry-run",
             description: "Print what would be done rather than doing it."
      switch "--no-commit",
             description: "Do not generate a new commit before uploading."
      switch "--warn-on-upload-failure",
             description: "Warn instead of raising an error if the bottle upload fails. "\
                          "Useful for repairing bottle uploads that previously failed."
      flag   "--archive-item=",
             description: "Upload to the specified Internet Archive item (default: `homebrew`)."
      flag   "--bintray-org=",
             description: "Upload to the specified Bintray organisation (default: `homebrew`)."
      flag   "--github-org=",
             description: "Upload to the specified GitHub organisation's GitHub Packages (default: `homebrew`)."
      flag   "--root-url=",
             description: "Use the specified <URL> as the root of the bottle's URL instead of Homebrew's default."

      named_args :none
    end
  end

  def check_bottled_formulae(bottles_hash)
    bottles_hash.each do |name, bottle_hash|
      formula_path = HOMEBREW_REPOSITORY/bottle_hash["formula"]["path"]
      formula_version = Formulary.factory(formula_path).pkg_version
      bottle_version = PkgVersion.parse bottle_hash["formula"]["pkg_version"]
      next if formula_version == bottle_version

      odie "Bottles are for #{name} #{bottle_version} but formula is version #{formula_version}!"
    end
  end

  def internet_archive?(bottles_hash)
    @internet_archive ||= bottles_hash.values.all? do |bottle_hash|
      bottle_hash["bottle"]["root_url"].start_with? "#{Archive::URL_PREFIX}/"
    end
  end

  def bintray?(bottles_hash)
    @bintray ||= bottles_hash.values.all? do |bottle_hash|
      bottle_hash["bottle"]["root_url"].match? Bintray::URL_REGEX
    end
  end

  def github_releases?(bottles_hash)
    @github_releases ||= bottles_hash.values.all? do |bottle_hash|
      root_url = bottle_hash["bottle"]["root_url"]
      url_match = root_url.match GitHubReleases::URL_REGEX
      _, _, _, tag = *url_match

      tag
    end
  end

  def github_packages?(bottles_hash)
    @github_packages ||= bottles_hash.values.all? do |bottle_hash|
      bottle_hash["bottle"]["root_url"].match? GitHubPackages::URL_REGEX
    end
  end

  def pr_upload
    args = pr_upload_args.parse

    json_files = Dir["*.bottle.json"]
    odie "No bottle JSON files found in the current working directory" if json_files.empty?

    bottles_hash = json_files.reduce({}) do |hash, json_file|
      hash.deep_merge(JSON.parse(IO.read(json_file)))
    end

    bottle_args = ["bottle", "--merge", "--write"]
    bottle_args << "--verbose" if args.verbose?
    bottle_args << "--debug" if args.debug?
    bottle_args << "--keep-old" if args.keep_old?
    bottle_args << "--root-url=#{args.root_url}" if args.root_url
    bottle_args << "--no-commit" if args.no_commit?
    bottle_args += json_files

    if args.dry_run?
      service =
        if internet_archive?(bottles_hash)
          "Internet Archive"
        elsif bintray?(bottles_hash)
          "Bintray"
        elsif github_releases?(bottles_hash)
          "GitHub Releases"
        elsif github_packages?(bottles_hash)
          "GitHub Packages"
        else
          odie "Service specified by root_url is not recognized"
        end
      puts <<~EOS
        brew #{bottle_args.join " "}
        Upload bottles described by these JSON files to #{service}:
          #{json_files.join("\n  ")}
      EOS
      return
    end

    check_bottled_formulae(bottles_hash)

    safe_system HOMEBREW_BREW_FILE, *bottle_args

    # Check the bottle commits did not break `brew audit`
    unless args.no_commit?
      audit_args = ["audit", "--skip-style"]
      audit_args << "--verbose" if args.verbose?
      audit_args << "--debug" if args.debug?
      audit_args += bottles_hash.keys
      safe_system HOMEBREW_BREW_FILE, *audit_args
    end

    if internet_archive?(bottles_hash)
      archive_item = args.archive_item || "homebrew"
      archive = Archive.new(item: archive_item)
      archive.upload_bottles(bottles_hash,
                             warn_on_error: args.warn_on_upload_failure?)
    elsif bintray?(bottles_hash)
      bintray_org = args.bintray_org || "homebrew"
      bintray = Bintray.new(org: bintray_org)
      bintray.upload_bottles(bottles_hash,
                             publish_package: !args.no_publish?,
                             warn_on_error:   args.warn_on_upload_failure?)
    elsif github_releases?(bottles_hash)
      github_releases = GitHubReleases.new
      github_releases.upload_bottles(bottles_hash)
    elsif github_packages?(bottles_hash)
      github_org = args.github_org || "homebrew"
      github_packages = GitHubPackages.new(org: github_org)
      github_packages.upload_bottles(bottles_hash)
    else
      odie "Service specified by root_url is not recognized"
    end
  end
end
