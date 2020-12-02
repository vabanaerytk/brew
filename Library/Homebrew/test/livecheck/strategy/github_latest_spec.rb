# typed: false
# frozen_string_literal: true

require "livecheck/strategy/github_latest"

describe Homebrew::Livecheck::Strategy::GithubLatest do
  subject(:github_latest) { described_class }

  let(:github_download_url) { "https://github.com/example/example/releases/download/1.2.3/example-1.2.3.zip" }
  let(:github_archive_url) { "https://github.com/example/example/archive/v1.2.3.tar.gz" }
  let(:non_github_url) { "https://brew.sh/test" }

  describe "::match?" do
    it "returns true if the argument provided is a GitHub Download URL" do
      expect(github_latest.match?(github_download_url)).to be true
    end

    it "returns true if the argument provided is a GitHub Archive URL" do
      expect(github_latest.match?(github_archive_url)).to be true
    end

    it "returns false if the argument provided is not a GitHub URL" do
      expect(github_latest.match?(non_github_url)).to be false
    end
  end
end
