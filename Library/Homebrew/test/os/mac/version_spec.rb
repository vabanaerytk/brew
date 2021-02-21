# typed: false
# frozen_string_literal: true

require "version"
require "os/mac/version"

describe OS::Mac::Version do
  let(:version) { described_class.new("10.14") }
  let(:big_sur_major) { described_class.new("11.0") }
  let(:big_sur_update) { described_class.new("11.1") }

  specify "comparison with Symbol" do
    expect(version).to be > :high_sierra
    expect(version).to be == :mojave
    expect(version).to be === :mojave # rubocop:disable Style/CaseEquality
    expect(version).to be < :catalina
  end

  specify "comparison with Fixnum" do
    expect(version).to be > 10
    expect(version).to be < 11
  end

  specify "comparison with Float" do
    expect(version).to be > 10.13
    expect(version).to be < 10.15
  end

  specify "comparison with String" do
    expect(version).to be > "10.3"
    expect(version).to be == "10.14"
    expect(version).to be === "10.14" # rubocop:disable Style/CaseEquality
    expect(version).to be < "10.15"
  end

  specify "comparison with Version" do
    expect(version).to be > Version.create("10.3")
    expect(version).to be == Version.create("10.14")
    expect(version).to be === Version.create("10.14") # rubocop:disable Style/CaseEquality
    expect(version).to be < Version.create("10.15")
  end

  describe "after Big Sur" do
    specify "comparison with :big_sur" do
      expect(big_sur_major).to eq :big_sur
      expect(big_sur_major).to be <= :big_sur
      expect(big_sur_major).to be >= :big_sur
      expect(big_sur_major).not_to be > :big_sur
      expect(big_sur_major).not_to be < :big_sur

      expect(big_sur_update).to eq :big_sur
      expect(big_sur_update).to be <= :big_sur
      expect(big_sur_update).to be >= :big_sur
      expect(big_sur_update).not_to be > :big_sur
      expect(big_sur_update).not_to be < :big_sur
    end
  end

  describe "#new" do
    it "raises an error if the version is not a valid macOS version" do
      expect {
        described_class.new("1.2")
      }.to raise_error(MacOSVersionError, 'unknown or unsupported macOS version: "1.2"')
    end

    it "creates a new version from a valid macOS version" do
      string_version = described_class.new("11")
      expect(string_version).to eq(:big_sur)
      expect(string_version.arch).to eq(:intel)
    end

    it "creates a new version from a valid macOS version with architecture" do
      string_version = described_class.new("11-arm64")
      expect(string_version).to eq(:big_sur)
      expect(string_version.arch).to eq(:arm64)
    end

    it "creates a new version from a valid macOS version and architecture" do
      string_version = described_class.new("11", arch: "arm64")
      expect(string_version).to eq(:big_sur)
      expect(string_version.arch).to eq(:arm64)
    end
  end

  describe "#from_symbol" do
    it "raises an error if the symbol is not a valid macOS version" do
      expect {
        described_class.from_symbol(:foo)
      }.to raise_error(MacOSVersionError, "unknown or unsupported macOS version: :foo")
    end

    it "creates a new version from a valid macOS version" do
      symbol_version = described_class.from_symbol(:mojave)
      expect(symbol_version).to eq(version)
      expect(symbol_version.arch).to eq(:intel)
    end

    it "creates a new version from a valid macOS version with architecture" do
      symbol_version = described_class.from_symbol(:arm64_big_sur)
      expect(symbol_version).to eq(:big_sur)
      expect(symbol_version.arch).to eq(:arm64)
    end
  end

  specify "#pretty_name" do
    expect(described_class.new("10.11").pretty_name).to eq("El Capitan")
    expect(described_class.new("10.14").pretty_name).to eq("Mojave")
    expect(described_class.new("10.10").pretty_name).to eq("Yosemite")
  end

  specify "#requires_nehalem_cpu?" do
    expect(Hardware::CPU).to receive(:type).at_least(:twice).and_return(:intel)
    expect(described_class.new("10.14").requires_nehalem_cpu?).to be true
    expect(described_class.new("10.12").requires_nehalem_cpu?).to be false
  end
end
