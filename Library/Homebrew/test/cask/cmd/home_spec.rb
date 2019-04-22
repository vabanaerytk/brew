# frozen_string_literal: true

require_relative "shared_examples/invalid_option"

describe Cask::Cmd::Home, :cask do
  before do
    allow(described_class).to receive(:open_url)
  end

  it_behaves_like "a command that handles invalid options"

  it "opens the homepage for the specified Cask" do
    expect(described_class).to receive(:open_url).with("https://brew.sh")
    described_class.run("local-caffeine")
  end

  it "works for multiple Casks" do
    expect(described_class).to receive(:open_url).with("https://brew.sh")
    expect(described_class).to receive(:open_url).with("https://brew.sh")
    described_class.run("local-caffeine", "local-transmission")
  end

  it "opens the project page when no Cask is specified" do
    expect(described_class).to receive(:open_url).with("https://brew.sh/")
    described_class.run
  end
end
