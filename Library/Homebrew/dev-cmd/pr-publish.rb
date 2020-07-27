# frozen_string_literal: true

require "cli/parser"
require "utils/github"

module Homebrew
  module_function

  def pr_publish_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `pr-publish` [<options>] <pull_request> [<pull_request> ...]

        Publish bottles for a pull request with GitHub Actions.
        Requires write access to the repository.
      EOS
      flag   "--tap=",
             description: "Target tap repository (default: `homebrew/core`)."
      switch :verbose
      min_named 1
    end
  end

  def pr_publish
    pr_publish_args.parse

    tap = Tap.fetch(Homebrew.args.tap || CoreTap.instance.name)

    args.named.uniq.each do |arg|
      arg = "#{tap.default_remote}/pull/#{arg}" if arg.to_i.positive?
      url_match = arg.match HOMEBREW_PULL_OR_COMMIT_URL_REGEX
      _, user, repo, issue = *url_match
      odie "Not a GitHub pull request: #{arg}" unless issue
      if args.tap.present? && !"#{user}/#{repo}".casecmp(tap.full_name).zero?
        odie "Pull request URL is for #{user}/#{repo} but --tap=#{tap.full_name}!"
      end

      ohai "Dispatching #{tap} pull request ##{issue}"
      GitHub.dispatch_event(user, repo, "Publish ##{issue}", pull_request: issue)
    end
  end
end
