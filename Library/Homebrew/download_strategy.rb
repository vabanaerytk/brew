require "json"
require "rexml/document"
require "time"
require "unpack_strategy"

class AbstractDownloadStrategy
  extend Forwardable
  include FileUtils

  module Pourable
    def stage
      ohai "Pouring #{cached_location.basename}"
      super
    end
  end

  attr_reader :cached_location
  attr_reader :meta, :name, :version, :shutup
  private :meta, :name, :version, :shutup

  def initialize(url, name, version, **meta)
    @url = url
    @name = name
    @version = version
    @cache = meta.fetch(:cache, HOMEBREW_CACHE)
    @meta = meta
    @shutup = false
    extend Pourable if meta[:bottle]
  end

  # Download and cache the resource as {#cached_location}.
  def fetch; end

  # Suppress output
  def shutup!
    @shutup = true
  end

  def puts(*args)
    super(*args) unless shutup
  end

  def ohai(*args)
    super(*args) unless shutup
  end

  # Unpack {#cached_location} into the current working directory, and possibly
  # chdir into the newly-unpacked directory.
  # Unlike {Resource#stage}, this does not take a block.
  def stage
    UnpackStrategy.detect(cached_location,
                          extension_only: true,
                          ref_type: @ref_type, ref: @ref)
                  .extract_nestedly(basename: basename_without_params,
                                    extension_only: true,
                                    verbose: ARGV.verbose? && !shutup)
    chdir
  end

  def chdir
    entries = Dir["*"]
    case entries.length
    when 0 then raise "Empty archive"
    when 1 then begin
        Dir.chdir entries.first
      rescue
        nil
      end
    end
  end
  private :chdir

  # @!attribute [r]
  # return most recent modified time for all files in the current working directory after stage.
  def source_modified_time
    Pathname.pwd.to_enum(:find).select(&:file?).map(&:mtime).max
  end

  # Remove {#cached_location} and any other files associated with the resource
  # from the cache.
  def clear_cache
    rm_rf(cached_location)
  end

  def basename_without_params
    return unless @url

    # Strip any ?thing=wad out of .c?thing=wad style extensions
    File.basename(@url)[/[^?]+/]
  end

  private

  def system_command(*args, **options)
    super(*args, print_stderr: false, env: env, **options)
  end

  def system_command!(*args, **options)
    super(
      *args,
      print_stdout: !shutup,
      print_stderr: !shutup,
      verbose: ARGV.verbose? && !shutup,
      env: env,
      **options,
    )
  end

  def env
    {}
  end
end

class VCSDownloadStrategy < AbstractDownloadStrategy
  REF_TYPES = [:tag, :branch, :revisions, :revision].freeze

  def initialize(url, name, version, **meta)
    super
    @ref_type, @ref = extract_ref(meta)
    @revision = meta[:revision]
    @cached_location = @cache/"#{name}--#{cache_tag}"
  end

  def fetch
    ohai "Cloning #{@url}"

    if cached_location.exist? && repo_valid?
      puts "Updating #{cached_location}"
      update
    elsif cached_location.exist?
      puts "Removing invalid repository from cache"
      clear_cache
      clone_repo
    else
      clone_repo
    end

    version.update_commit(last_commit) if head?

    return unless @ref_type == :tag
    return unless @revision && current_revision
    return if current_revision == @revision
    raise <<~EOS
      #{@ref} tag should be #{@revision}
      but is actually #{current_revision}
    EOS
  end

  def fetch_last_commit
    fetch
    last_commit
  end

  def commit_outdated?(commit)
    @last_commit ||= fetch_last_commit
    commit != @last_commit
  end

  def head?
    version.respond_to?(:head?) && version.head?
  end

  # Return last commit's unique identifier for the repository.
  # Return most recent modified timestamp unless overridden.
  def last_commit
    source_modified_time.to_i.to_s
  end

  private

  def cache_tag
    raise NotImplementedError
  end

  def repo_valid?
    raise NotImplementedError
  end

  def clone_repo; end

  def update; end

  def current_revision; end

  def extract_ref(specs)
    key = REF_TYPES.find { |type| specs.key?(type) }
    [key, specs[key]]
  end
end

class AbstractFileDownloadStrategy < AbstractDownloadStrategy
  attr_reader :temporary_path

  def initialize(url, name, version, **meta)
    super
    @cached_location = @cache/"#{name}--#{version}#{ext}"
    @temporary_path = Pathname.new("#{cached_location}.incomplete")
  end

  private

  def ext
    uri_path = if URI::DEFAULT_PARSER.make_regexp =~ @url
      uri = URI(@url)
      uri.query ? "#{uri.path}?#{uri.query}" : uri.path
    else
      @url
    end

    # We need a Pathname because we've monkeypatched extname to support double
    # extensions (e.g. tar.gz).
    # We can't use basename_without_params, because given a URL like
    #   https://example.com/download.php?file=foo-1.0.tar.gz
    # the extension we want is ".tar.gz", not ".php".
    Pathname.new(uri_path).ascend do |path|
      ext = path.extname[/[^?&]+/]
      return ext if ext
    end
    nil
  end
end

class CurlDownloadStrategy < AbstractFileDownloadStrategy
  attr_reader :mirrors

  def initialize(url, name, version, **meta)
    super
    @mirrors = meta.fetch(:mirrors, [])
  end

  def fetch
    ohai "Downloading #{@url}"

    if cached_location.exist?
      puts "Already downloaded: #{cached_location}"
    else
      begin
        _fetch
      rescue ErrorDuringExecution
        raise CurlDownloadStrategyError, @url
      end
      ignore_interrupts { temporary_path.rename(cached_location) }
    end
  rescue CurlDownloadStrategyError
    raise if mirrors.empty?
    puts "Trying a mirror..."
    @url = mirrors.shift
    retry
  end

  def clear_cache
    super
    rm_rf(temporary_path)
  end

  private

  # Private method, can be overridden if needed.
  def _fetch
    url = @url

    if ENV["HOMEBREW_ARTIFACT_DOMAIN"]
      url = url.sub(%r{^((ht|f)tps?://)?}, ENV["HOMEBREW_ARTIFACT_DOMAIN"].chomp("/") + "/")
      ohai "Downloading from #{url}"
    end

    temporary_path.dirname.mkpath

    curl_download resolved_url(url), to: temporary_path
  end

  # Curl options to be always passed to curl,
  # with raw head calls (`curl --head`) or with actual `fetch`.
  def _curl_args
    args = []

    if meta.key?(:cookies)
      escape_cookie = ->(cookie) { URI.encode_www_form([cookie]) }
      args += ["-b", meta.fetch(:cookies).map(&escape_cookie).join(";")]
    end

    args += ["-e", meta.fetch(:referer)] if meta.key?(:referer)

    args += ["--user", meta.fetch(:user)] if meta.key?(:user)

    args
  end

  def _curl_opts
    return { user_agent: meta.fetch(:user_agent) } if meta.key?(:user_agent)
    {}
  end

  def resolved_url(url)
    redirect_url, _, status = curl_output(
      "--silent", "--head",
      "--write-out", "%{redirect_url}",
      "--output", "/dev/null",
      url.to_s
    )

    return url unless status.success?
    return url if redirect_url.empty?

    ohai "Downloading from #{redirect_url}"
    if ENV["HOMEBREW_NO_INSECURE_REDIRECT"] &&
       url.start_with?("https://") && !redirect_url.start_with?("https://")
      puts "HTTPS to HTTP redirect detected & HOMEBREW_NO_INSECURE_REDIRECT is set."
      raise CurlDownloadStrategyError, url
    end

    redirect_url
  end

  def curl_output(*args, **options)
    super(*_curl_args, *args, **_curl_opts, **options)
  end

  def curl(*args, **options)
    args << "--connect-timeout" << "5" unless mirrors.empty?
    super(*_curl_args, *args, **_curl_opts, **options)
  end
end

# Detect and download from Apache Mirror
class CurlApacheMirrorDownloadStrategy < CurlDownloadStrategy
  def apache_mirrors
    mirrors, = curl_output("--silent", "--location", "#{@url}&asjson=1")
    JSON.parse(mirrors)
  end

  def _fetch
    return super if @tried_apache_mirror
    @tried_apache_mirror = true

    mirrors = apache_mirrors
    path_info = mirrors.fetch("path_info")
    @url = mirrors.fetch("preferred") + path_info
    @mirrors |= %W[https://archive.apache.org/dist/#{path_info}]

    ohai "Best Mirror #{@url}"
    super
  rescue IndexError, JSON::ParserError
    raise CurlDownloadStrategyError, "Couldn't determine mirror, try again later."
  end
end

# Download via an HTTP POST.
# Query parameters on the URL are converted into POST parameters
class CurlPostDownloadStrategy < CurlDownloadStrategy
  def _fetch
    args = if meta.key?(:data)
      escape_data = ->(d) { ["-d", URI.encode_www_form([d])] }
      [@url, *meta[:data].flat_map(&escape_data)]
    else
      url, query = @url.split("?", 2)
      query.nil? ? [url, "-X", "POST"] : [url, "-d", query]
    end

    curl_download(*args, to: temporary_path)
  end
end

# Use this strategy to download but not unzip a file.
# Useful for installing jars.
class NoUnzipCurlDownloadStrategy < CurlDownloadStrategy
  def stage
    UnpackStrategy::Uncompressed.new(cached_location)
                                .extract(basename: basename_without_params,
                                         verbose: ARGV.verbose? && !shutup)
  end
end

# This strategy extracts local binary packages.
class LocalBottleDownloadStrategy < AbstractFileDownloadStrategy
  def initialize(path)
    @cached_location = path
  end
end

# S3DownloadStrategy downloads tarballs from AWS S3.
# To use it, add `:using => :s3` to the URL section of your
# formula.  This download strategy uses AWS access tokens (in the
# environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY)
# to sign the request.  This strategy is good in a corporate setting,
# because it lets you use a private S3 bucket as a repo for internal
# distribution.  (It will work for public buckets as well.)
class S3DownloadStrategy < CurlDownloadStrategy
  def _fetch
    if @url !~ %r{^https?://([^.].*)\.s3\.amazonaws\.com/(.+)$} &&
       @url !~ %r{^s3://([^.].*?)/(.+)$}
      raise "Bad S3 URL: " + @url
    end
    bucket = Regexp.last_match(1)
    key = Regexp.last_match(2)

    ENV["AWS_ACCESS_KEY_ID"] = ENV["HOMEBREW_AWS_ACCESS_KEY_ID"]
    ENV["AWS_SECRET_ACCESS_KEY"] = ENV["HOMEBREW_AWS_SECRET_ACCESS_KEY"]

    begin
      signer = Aws::S3::Presigner.new
      s3url = signer.presigned_url :get_object, bucket: bucket, key: key
    rescue Aws::Sigv4::Errors::MissingCredentialsError
      ohai "AWS credentials missing, trying public URL instead."
      s3url = @url
    end

    curl_download s3url, to: temporary_path
  end
end

# GitHubPrivateRepositoryDownloadStrategy downloads contents from GitHub
# Private Repository. To use it, add
# `:using => :github_private_repo` to the URL section of
# your formula. This download strategy uses GitHub access tokens (in the
# environment variables HOMEBREW_GITHUB_API_TOKEN) to sign the request.  This
# strategy is suitable for corporate use just like S3DownloadStrategy, because
# it lets you use a private GitHub repository for internal distribution.  It
# works with public one, but in that case simply use CurlDownloadStrategy.
class GitHubPrivateRepositoryDownloadStrategy < CurlDownloadStrategy
  require "utils/formatter"
  require "utils/github"

  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Repository."
    end

    _, @owner, @repo, @filepath = *@url.match(url_pattern)
  end

  def download_url
    "https://#{@github_token}@github.com/#{@owner}/#{@repo}/#{@filepath}"
  end

  def _fetch
    curl_download download_url, to: temporary_path
  end

  private

  def set_github_token
    @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"]
    unless @github_token
      raise CurlDownloadStrategyError, "Environmental variable HOMEBREW_GITHUB_API_TOKEN is required."
    end
    validate_github_repository_access!
  end

  def validate_github_repository_access!
    # Test access to the repository
    GitHub.repository(@owner, @repo)
  rescue GitHub::HTTPNotFoundError
    # We only handle HTTPNotFoundError here,
    # becase AuthenticationFailedError is handled within util/github.
    message = <<~EOS
      HOMEBREW_GITHUB_API_TOKEN can not access the repository: #{@owner}/#{@repo}
      This token may not have permission to access the repository or the url of formula may be incorrect.
    EOS
    raise CurlDownloadStrategyError, message
  end
end

# GitHubPrivateRepositoryReleaseDownloadStrategy downloads tarballs from GitHub
# Release assets. To use it, add `:using => :github_private_release` to the URL section
# of your formula. This download strategy uses GitHub access tokens (in the
# environment variables HOMEBREW_GITHUB_API_TOKEN) to sign the request.
class GitHubPrivateRepositoryReleaseDownloadStrategy < GitHubPrivateRepositoryDownloadStrategy
  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
    end

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def download_url
    "https://#{@github_token}@api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  def _fetch
    # HTTP request header `Accept: application/octet-stream` is required.
    # Without this, the GitHub API will respond with metadata, not binary.
    curl_download download_url, "--header", "Accept: application/octet-stream", to: temporary_path
  end

  private

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata["assets"].select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found." if assets.empty?

    assets.first["id"]
  end

  def fetch_release_metadata
    release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    GitHub.open_api(release_url)
  end
end

# ScpDownloadStrategy downloads files using ssh via scp. To use it, add
# `:using => :scp` to the URL section of your formula or
# provide a URL starting with scp://. This strategy uses ssh credentials for
# authentication. If a public/private keypair is configured, it will not
# prompt for a password.
#
# Usage:
#
#   class Abc < Formula
#     url "scp://example.com/src/abc.1.0.tar.gz"
#     ...
class ScpDownloadStrategy < AbstractFileDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
  end

  def parse_url_pattern
    url_pattern = %r{scp://([^@]+@)?([^@:/]+)(:\d+)?/(\S+)}
    if @url !~ url_pattern
      raise ScpDownloadStrategyError, "Invalid URL for scp: #{@url}"
    end

    _, @user, @host, @port, @path = *@url.match(url_pattern)
  end

  def fetch
    ohai "Downloading #{@url}"

    if cached_location.exist?
      puts "Already downloaded: #{cached_location}"
    else
      system_command! "scp", args: [scp_source, temporary_path.to_s]
      ignore_interrupts { temporary_path.rename(cached_location) }
    end
  end

  def clear_cache
    super
    rm_rf(temporary_path)
  end

  private

  def scp_source
    path_prefix = "/" unless @path.start_with?("~")
    port_arg = "-P #{@port[1..-1]} " if @port
    "#{port_arg}#{@user}#{@host}:#{path_prefix}#{@path}"
  end
end

class SubversionDownloadStrategy < VCSDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    @url = @url.sub("svn+http://", "")
  end

  def fetch
    if @url.chomp("/") != repo_url || !system_command("svn", args: ["switch", @url, cached_location]).success?
      clear_cache
    end
    super
  end

  def source_modified_time
    out, = system_command("svn", args: ["info", "--xml"], chdir: cached_location)
    xml = REXML::Document.new(out)
    Time.parse REXML::XPath.first(xml, "//date/text()").to_s
  end

  def last_commit
    out, = system_command("svn", args: ["info", "--show-item", "revision"], chdir: cached_location)
    out.strip
  end

  private

  def repo_url
    out, = system_command("svn", args: ["info"], chdir: cached_location)
    out.strip[/^URL: (.+)$/, 1]
  end

  def externals
    out, = system_command("svn", args: ["propget", "svn:externals", @url])
    out.chomp.split("\n").each do |line|
      name, url = line.split(/\s+/)
      yield name, url
    end
  end

  def fetch_repo(target, url, revision = nil, ignore_externals = false)
    # Use "svn update" when the repository already exists locally.
    # This saves on bandwidth and will have a similar effect to verifying the
    # cache as it will make any changes to get the right revision.
    args = []

    if revision
      ohai "Checking out #{@ref}"
      args << "-r" << revision
    end

    args << "--ignore-externals" if ignore_externals

    if meta[:trust_cert] == true
      args << "--trust-server-cert"
      args << "--non-interactive"
    end

    if target.directory?
      system_command!("svn", args: ["update", *args], chdir: target.to_s)
    else
      system_command!("svn", args: ["checkout", url, target, *args])
    end
  end

  def cache_tag
    head? ? "svn-HEAD" : "svn"
  end

  def repo_valid?
    (cached_location/".svn").directory?
  end

  def clone_repo
    case @ref_type
    when :revision
      fetch_repo cached_location, @url, @ref
    when :revisions
      # nil is OK for main_revision, as fetch_repo will then get latest
      main_revision = @ref[:trunk]
      fetch_repo cached_location, @url, main_revision, true

      externals do |external_name, external_url|
        fetch_repo cached_location/external_name, external_url, @ref[external_name], true
      end
    else
      fetch_repo cached_location, @url
    end
  end
  alias update clone_repo
end

class GitDownloadStrategy < VCSDownloadStrategy
  SHALLOW_CLONE_WHITELIST = [
    %r{git://},
    %r{https://github\.com},
    %r{http://git\.sv\.gnu\.org},
    %r{http://llvm\.org},
  ].freeze

  def initialize(url, name, version, **meta)
    super
    @ref_type ||= :branch
    @ref ||= "master"
    @shallow = meta.fetch(:shallow) { true }
  end

  def source_modified_time
    out, = system_command("git", args: ["--git-dir", git_dir, "show", "-s", "--format=%cD"])
    Time.parse(out)
  end

  def last_commit
    out, = system_command("git", args: ["--git-dir", git_dir, "rev-parse", "--short=7", "HEAD"])
    out.chomp
  end

  private

  def cache_tag
    "git"
  end

  def cache_version
    0
  end

  def update
    config_repo
    update_repo
    checkout
    reset
    update_submodules if submodules?
  end

  def shallow_clone?
    @shallow && support_depth?
  end

  def shallow_dir?
    (git_dir/"shallow").exist?
  end

  def support_depth?
    @ref_type != :revision && SHALLOW_CLONE_WHITELIST.any? { |regex| @url =~ regex }
  end

  def git_dir
    cached_location/".git"
  end

  def ref?
    system_command("git",
                   args: ["--git-dir", git_dir, "rev-parse", "-q", "--verify", "#{@ref}^{commit}"])
      .success?
  end

  def current_revision
    out, = system_command("git", args: ["--git-dir", git_dir, "rev-parse", "-q", "--verify", "HEAD"])
    out.strip
  end

  def repo_valid?
    system_command("git", args: ["--git-dir", git_dir, "status", "-s"]).success?
  end

  def submodules?
    (cached_location/".gitmodules").exist?
  end

  def clone_args
    args = %w[clone]
    args << "--depth" << "1" if shallow_clone?

    case @ref_type
    when :branch, :tag
      args << "--branch" << @ref
    end

    args << @url << cached_location
  end

  def refspec
    case @ref_type
    when :branch then "+refs/heads/#{@ref}:refs/remotes/origin/#{@ref}"
    when :tag    then "+refs/tags/#{@ref}:refs/tags/#{@ref}"
    else              "+refs/heads/master:refs/remotes/origin/master"
    end
  end

  def config_repo
    system_command! "git",
                    args: ["config", "remote.origin.url", @url],
                    chdir: cached_location
    system_command! "git",
                    args: ["config", "remote.origin.fetch", refspec],
                    chdir: cached_location
  end

  def update_repo
    return unless @ref_type == :branch || !ref?

    if !shallow_clone? && shallow_dir?
      system_command! "git",
                      args: ["fetch", "origin", "--unshallow"],
                      chdir: cached_location
    else
      system_command! "git",
                      args: ["fetch", "origin"],
                      chdir: cached_location
    end
  end

  def clone_repo
    system_command! "git", args: clone_args

    system_command! "git",
                    args: ["config", "homebrew.cacheversion", cache_version],
                    chdir: cached_location
    checkout
    update_submodules if submodules?
  end

  def checkout
    ohai "Checking out #{@ref_type} #{@ref}" if @ref_type && @ref
    system_command! "git", args: ["checkout", "-f", @ref, "--"], chdir: cached_location
  end

  def reset
    ref = case @ref_type
    when :branch
      "origin/#{@ref}"
    when :revision, :tag
      @ref
    end

    system_command! "git",
                    args: ["reset", "--hard", *ref],
                    chdir: cached_location
  end

  def update_submodules
    system_command! "git",
                    args: ["submodule", "foreach", "--recursive", "git submodule sync"],
                    chdir: cached_location
    system_command! "git",
                    args: ["submodule", "update", "--init", "--recursive"],
                    chdir: cached_location
    fix_absolute_submodule_gitdir_references!
  end

  # When checking out Git repositories with recursive submodules, some Git
  # versions create `.git` files with absolute instead of relative `gitdir:`
  # pointers. This works for the cached location, but breaks various Git
  # operations once the affected Git resource is staged, i.e. recursively
  # copied to a new location. (This bug was introduced in Git 2.7.0 and fixed
  # in 2.8.3. Clones created with affected version remain broken.)
  # See https://github.com/Homebrew/homebrew-core/pull/1520 for an example.
  def fix_absolute_submodule_gitdir_references!
    submodule_dirs = system_command!("git",
                                     args: ["submodule", "--quiet", "foreach", "--recursive", "pwd"],
                                     chdir: cached_location).stdout

    submodule_dirs.lines.map(&:chomp).each do |submodule_dir|
      work_dir = Pathname.new(submodule_dir)

      # Only check and fix if `.git` is a regular file, not a directory.
      dot_git = work_dir/".git"
      next unless dot_git.file?

      git_dir = dot_git.read.chomp[/^gitdir: (.*)$/, 1]
      if git_dir.nil?
        onoe "Failed to parse '#{dot_git}'." if ARGV.homebrew_developer?
        next
      end

      # Only attempt to fix absolute paths.
      next unless git_dir.start_with?("/")

      # Make the `gitdir:` reference relative to the working directory.
      relative_git_dir = Pathname.new(git_dir).relative_path_from(work_dir)
      dot_git.atomic_write("gitdir: #{relative_git_dir}\n")
    end
  end
end

class GitHubGitDownloadStrategy < GitDownloadStrategy
  def initialize(url, name, version, **meta)
    super

    return unless %r{^https?://github\.com/(?<user>[^/]+)/(?<repo>[^/]+)\.git$} =~ @url
    @user = user
    @repo = repo
  end

  def github_last_commit
    return if ENV["HOMEBREW_NO_GITHUB_API"]

    output, _, status = curl_output(
      "--silent", "--head", "--location",
      "-H", "Accept: application/vnd.github.v3.sha",
      "https://api.github.com/repos/#{@user}/#{@repo}/commits/#{@ref}"
    )

    return unless status.success?

    commit = output[/^ETag: \"(\h+)\"/, 1]
    version.update_commit(commit) if commit
    commit
  end

  def multiple_short_commits_exist?(commit)
    return if ENV["HOMEBREW_NO_GITHUB_API"]

    output, _, status = curl_output(
      "--silent", "--head", "--location",
      "-H", "Accept: application/vnd.github.v3.sha",
      "https://api.github.com/repos/#{@user}/#{@repo}/commits/#{commit}"
    )

    !(status.success? && output && output[/^Status: (200)/, 1] == "200")
  end

  def commit_outdated?(commit)
    @last_commit ||= github_last_commit
    if !@last_commit
      super
    else
      return true unless commit
      return true unless @last_commit.start_with?(commit)
      if multiple_short_commits_exist?(commit)
        true
      else
        version.update_commit(commit)
        false
      end
    end
  end
end

class CVSDownloadStrategy < VCSDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    @url = @url.sub(%r{^cvs://}, "")

    if meta.key?(:module)
      @module = meta.fetch(:module)
    elsif @url !~ %r{:[^/]+$}
      @module = name
    else
      @module, @url = split_url(@url)
    end
  end

  def source_modified_time
    # Filter CVS's files because the timestamp for each of them is the moment
    # of clone.
    max_mtime = Time.at(0)
    cached_location.find do |f|
      Find.prune if f.directory? && f.basename.to_s == "CVS"
      next unless f.file?
      mtime = f.mtime
      max_mtime = mtime if mtime > max_mtime
    end
    max_mtime
  end

  private

  def env
    { "PATH" => PATH.new("/usr/bin", Formula["cvs"].opt_bin, ENV["PATH"]) }
  end

  def cache_tag
    "cvs"
  end

  def repo_valid?
    (cached_location/"CVS").directory?
  end

  def quiet_flag
    "-Q" unless ARGV.verbose?
  end

  def clone_repo
    # Login is only needed (and allowed) with pserver; skip for anoncvs.
    system_command! "cvs", args: [*quiet_flag, "-d", @url, "login"] if @url.include? "pserver"

    system_command! "cvs",
                    args: [*quiet_flag, "-d", @url, "checkout", "-d", cached_location.basename, @module],
                    chdir: cached_location.dirname
  end

  def update
    system_command! "cvs",
                    args: [*quiet_flag, "update"],
                    chdir: cached_location
  end

  def split_url(in_url)
    parts = in_url.split(/:/)
    mod = parts.pop
    url = parts.join(":")
    [mod, url]
  end
end

class MercurialDownloadStrategy < VCSDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    @url = @url.sub(%r{^hg://}, "")
  end

  def source_modified_time
    out, = system_command("hg",
                          args: ["tip", "--template", "{date|isodate}", "-R", cached_location])

    Time.parse(out)
  end

  def last_commit
    out, = system_command("hg", args: ["parent", "--template", "{node|short}", "-R", cached_location])
    out.chomp
  end

  private

  def env
    { "PATH" => PATH.new(Formula["mercurial"].opt_bin, ENV["PATH"]) }
  end

  def cache_tag
    "hg"
  end

  def repo_valid?
    (cached_location/".hg").directory?
  end

  def clone_repo
    system_command! "hg", args: ["clone", @url, cached_location]
  end

  def update
    system_command! "hg", args: ["--cwd", cached_location, "pull", "--update"]

    update_args = if @ref_type && @ref
      ohai "Checking out #{@ref_type} #{@ref}"
      [@ref]
    else
      ["--clean"]
    end

    system_command! "hg", args: ["--cwd", cached_location, "update", *update_args]
  end
end

class BazaarDownloadStrategy < VCSDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    @url.sub!(%r{^bzr://}, "")
  end

  def source_modified_time
    out, = system_command("bzr", args: ["log", "-l", "1", "--timezone=utc", cached_location])
    timestamp = out.chomp
    raise "Could not get any timestamps from bzr!" if timestamp.to_s.empty?
    Time.parse(timestamp)
  end

  def last_commit
    out, = system_command("bzr", args: ["revno", cached_location])
    out.chomp
  end

  private

  def env
    {
      "PATH" => PATH.new(Formula["bazaar"].opt_bin, ENV["PATH"]),
      "BZR_HOME" => HOMEBREW_TEMP,
    }
  end

  def cache_tag
    "bzr"
  end

  def repo_valid?
    (cached_location/".bzr").directory?
  end

  def clone_repo
    # "lightweight" means history-less
    system_command! "bzr",
                    args: ["checkout", "--lightweight", @url, cached_location]
  end

  def update
    system_command! "bzr",
                    args: ["update"],
                    chdir: cached_location
  end
end

class FossilDownloadStrategy < VCSDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    @url = @url.sub(%r{^fossil://}, "")
  end

  def source_modified_time
    out, = system_command("fossil", args: ["info", "tip", "-R", cached_location])
    Time.parse(out[/^uuid: +\h+ (.+)$/, 1])
  end

  def last_commit
    out, = system_command("fossil", args: ["info", "tip", "-R", cached_location])
    out[/^uuid: +(\h+) .+$/, 1]
  end

  def repo_valid?
    system_command("fossil", args: ["branch", "-R", cached_location]).success?
  end

  private

  def env
    { "PATH" => PATH.new(Formula["fossil"].opt_bin, ENV["PATH"]) }
  end

  def cache_tag
    "fossil"
  end

  def clone_repo
    system_command!("fossil", args: ["clone", @url, cached_location])
  end

  def update
    system_command!("fossil", args: ["pull", "-R", cached_location])
  end
end

class DownloadStrategyDetector
  def self.detect(url, using = nil)
    strategy = if using.nil?
      detect_from_url(url)
    elsif using.is_a?(Class) && using < AbstractDownloadStrategy
      using
    elsif using.is_a?(Symbol)
      detect_from_symbol(using)
    else
      raise TypeError,
        "Unknown download strategy specification #{strategy.inspect}"
    end

    require_aws_sdk if strategy == S3DownloadStrategy

    strategy
  end

  def self.detect_from_url(url)
    case url
    when %r{^https?://github\.com/[^/]+/[^/]+\.git$}
      GitHubGitDownloadStrategy
    when %r{^https?://.+\.git$}, %r{^git://}
      GitDownloadStrategy
    when %r{^https?://www\.apache\.org/dyn/closer\.cgi}, %r{^https?://www\.apache\.org/dyn/closer\.lua}
      CurlApacheMirrorDownloadStrategy
    when %r{^https?://(.+?\.)?googlecode\.com/svn}, %r{^https?://svn\.}, %r{^svn://}, %r{^https?://(.+?\.)?sourceforge\.net/svnroot/}
      SubversionDownloadStrategy
    when %r{^cvs://}
      CVSDownloadStrategy
    when %r{^hg://}, %r{^https?://(.+?\.)?googlecode\.com/hg}
      MercurialDownloadStrategy
    when %r{^bzr://}
      BazaarDownloadStrategy
    when %r{^fossil://}
      FossilDownloadStrategy
    when %r{^svn\+http://}, %r{^http://svn\.apache\.org/repos/}
      SubversionDownloadStrategy
    when %r{^https?://(.+?\.)?sourceforge\.net/hgweb/}
      MercurialDownloadStrategy
    when %r{^s3://}
      S3DownloadStrategy
    when %r{^scp://}
      ScpDownloadStrategy
    else
      CurlDownloadStrategy
    end
  end

  def self.detect_from_symbol(symbol)
    case symbol
    when :hg                     then MercurialDownloadStrategy
    when :nounzip                then NoUnzipCurlDownloadStrategy
    when :git                    then GitDownloadStrategy
    when :github_private_repo    then GitHubPrivateRepositoryDownloadStrategy
    when :github_private_release then GitHubPrivateRepositoryReleaseDownloadStrategy
    when :bzr                    then BazaarDownloadStrategy
    when :s3                     then S3DownloadStrategy
    when :scp                    then ScpDownloadStrategy
    when :svn                    then SubversionDownloadStrategy
    when :curl                   then CurlDownloadStrategy
    when :cvs                    then CVSDownloadStrategy
    when :post                   then CurlPostDownloadStrategy
    when :fossil                 then FossilDownloadStrategy
    else
      raise "Unknown download strategy #{symbol} was requested."
    end
  end

  def self.require_aws_sdk
    Homebrew.install_gem! "aws-sdk-s3", "~> 1.8"
    require "aws-sdk-s3"
  end
end
