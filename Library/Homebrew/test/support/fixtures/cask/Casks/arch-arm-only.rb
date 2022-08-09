cask "arch-arm-only" do
  version "1.2.3"
  sha256 "67cdb8a02803ef37fdbf7e0be205863172e41a561ca446cd84f0d7ab35a99d94"
  arch arm: "-arm"

  url "file://#{TEST_FIXTURE_DIR}/cask/caffeine#{arch}.zip"
  homepage "https://brew.sh/"

  app "Caffeine.app"
end
