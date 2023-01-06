# typed: false
# frozen_string_literal: true

require "api"

describe Homebrew::API::Cask do
  let(:cache_dir) { mktmpdir }

  before do
    stub_const("Homebrew::API::HOMEBREW_CACHE_API", cache_dir)
  end

  def mock_curl_download(stdout:)
    allow(Utils::Curl).to receive(:curl_download) do |*_args, **kwargs|
      kwargs[:to].write stdout
    end
  end

  describe "::all_casks" do
    let(:casks_json) {
      <<~EOS
        [{
          "token": "foo",
          "url": "https://brew.sh/foo"
        }, {
          "token": "bar",
          "url": "https://brew.sh/bar"
        }]
      EOS
    }
    let(:casks_hash) {
      {
        "foo" => { "url" => "https://brew.sh/foo" },
        "bar" => { "url" => "https://brew.sh/bar" },
      }
    }

    it "returns the expected cask JSON list" do
      mock_curl_download stdout: casks_json
      casks_output = described_class.all_casks
      expect(casks_output).to eq casks_hash
    end
  end
end
