cask "multiple-versions" do
  arch = "arm"
  version "1.2.3"
  sha256 "67cdb8a02803ef37fdbf7e0be205863172e41a561ca446cd84f0d7ab35a99d94"

  on_intel do
    arch = "intel"
  end

  on_big_sur do
    version "1.2.0"
    sha256 "8c62a2b791cf5f0da6066a0a4b6e85f62949cd60975da062df44adf887f4370b"
  end

  on_catalina :or_older do
    version "1.0.0"
    sha256 "1866dfa833b123bb8fe7fa7185ebf24d28d300d0643d75798bc23730af734216"
  end

  url "file://#{TEST_FIXTURE_DIR}/cask/caffeine/#{version}/#{arch}.zip"
  homepage "https://brew.sh/"

  app "Caffeine.app"
end
