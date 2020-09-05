# frozen_string_literal: true

require "utils/curl"

# Auditing functions for rules common to both casks and formulae.
#
# @api private
module SharedAudits
  module_function

  def github_repo_data(user, repo)
    @github_repo_data ||= {}
    @github_repo_data["#{user}/#{repo}"] ||= GitHub.repository(user, repo)

    @github_repo_data["#{user}/#{repo}"]
  rescue GitHub::HTTPNotFoundError
    nil
  end

  def github_release_data(user, repo, tag)
    id = "#{user}/#{repo}/#{tag}"
    @github_release_data ||= {}
    @github_release_data[id] ||= GitHub.open_api("#{GitHub::API_URL}/repos/#{user}/#{repo}/releases/tags/#{tag}")

    @github_release_data[id]
  rescue GitHub::HTTPNotFoundError
    nil
  end

  GITHUB_PRERELEASE_ALLOWLIST = {
    "amd-power-gadget" => :all,
    "cbmc"             => "5.12.6",
    "elm-format"       => "0.8.3",
    "gitless"          => "0.8.8",
    "infrakit"         => "0.5",
    "riff"             => "0.5.0",
    "telegram-cli"     => "1.3.1",
    "volta"            => "0.8.6",
  }.freeze

  def github_release(user, repo, tag, formula: nil, cask: nil)
    release = github_release_data(user, repo, tag)
    return unless release

    if cask && GITHUB_PRERELEASE_ALLOWLIST[cask.token] == :all
      return if release["prerelease"]

      return "#{tag} is not a GitHub pre-release but cask '#{cask.token}' is in GITHUB_PRERELEASE_ALLOWLIST."
    end

    if release["prerelease"]
      return if formula && GITHUB_PRERELEASE_ALLOWLIST[formula.name] == formula.version

      return "#{tag} is a GitHub pre-release."
    end

    return "#{tag} is a GitHub draft." if release["draft"]
  end

  def gitlab_repo_data(user, repo)
    @gitlab_repo_data ||= {}
    @gitlab_repo_data["#{user}/#{repo}"] ||= begin
      out, _, status= curl_output("--request", "GET", "https://gitlab.com/api/v4/projects/#{user}%2F#{repo}")
      return unless status.success?

      JSON.parse(out)
    end

    @gitlab_repo_data["#{user}/#{repo}"]
  end

  def gitlab_release_data(user, repo, tag)
    id = "#{user}/#{repo}/#{tag}"
    @gitlab_release_data ||= {}
    @gitlab_release_data[id] ||= begin
      out, _, status= curl_output(
        "https://gitlab.com/api/v4/projects/#{user}%2F#{repo}/releases/#{tag}", "--fail"
      )
      return unless status.success?

      JSON.parse(out)
    end

    @gitlab_release_data[id]
  end

  GITLAB_PRERELEASE_ALLOWLIST = {}.freeze

  def gitlab_release(user, repo, tag, formula: nil)
    release = gitlab_release_data(user, repo, tag)
    return unless release

    return if Date.parse(release["released_at"]) <= Date.today
    return if formula && GITLAB_PRERELEASE_ALLOWLIST[formula.name] == formula.version

    "#{tag} is a GitLab pre-release."
  end

  GITHUB_FORK_ALLOWLIST = %w[
    variar/klogg
  ].freeze

  def github(user, repo)
    metadata = github_repo_data(user, repo)

    return if metadata.nil?

    if metadata["fork"] && !GITHUB_FORK_ALLOWLIST.include?("#{user}/#{repo}")
      return "GitHub fork (not canonical repository)"
    end

    if (metadata["forks_count"] < 30) && (metadata["subscribers_count"] < 30) &&
       (metadata["stargazers_count"] < 75)
      return "GitHub repository not notable enough (<30 forks, <30 watchers and <75 stars)"
    end

    return if Date.parse(metadata["created_at"]) <= (Date.today - 30)

    "GitHub repository too new (<30 days old)"
  end

  def gitlab(user, repo)
    metadata = gitlab_repo_data(user, repo)

    return if metadata.nil?

    return "GitLab fork (not canonical repository)" if metadata["fork"]
    if (metadata["forks_count"] < 30) && (metadata["star_count"] < 75)
      return "GitLab repository not notable enough (<30 forks and <75 stars)"
    end

    return if Date.parse(metadata["created_at"]) <= (Date.today - 30)

    "GitLab repository too new (<30 days old)"
  end

  def bitbucket(user, repo)
    api_url = "https://api.bitbucket.org/2.0/repositories/#{user}/#{repo}"
    out, _, status= curl_output("--request", "GET", api_url)
    return unless status.success?

    metadata = JSON.parse(out)
    return if metadata.nil?

    return "Uses deprecated mercurial support in Bitbucket" if metadata["scm"] == "hg"

    return "Bitbucket fork (not canonical repository)" unless metadata["parent"].nil?

    return "Bitbucket repository too new (<30 days old)" if Date.parse(metadata["created_on"]) >= (Date.today - 30)

    forks_out, _, forks_status= curl_output("--request", "GET", "#{api_url}/forks")
    return unless forks_status.success?

    watcher_out, _, watcher_status= curl_output("--request", "GET", "#{api_url}/watchers")
    return unless watcher_status.success?

    forks_metadata = JSON.parse(forks_out)
    return if forks_metadata.nil?

    watcher_metadata = JSON.parse(watcher_out)
    return if watcher_metadata.nil?

    return if (forks_metadata["size"] < 30) && (watcher_metadata["size"] < 75)

    "Bitbucket repository not notable enough (<30 forks and <75 watchers)"
  end
end
