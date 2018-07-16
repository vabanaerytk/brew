require "hbc/container/base"

module Hbc
  class Container
    class Air < Base
      def self.me?(criteria)
        criteria.path.extname == ".air"
      end

      def extract
        unpack_dir = @cask.staged_path

        @command.run!(
          "/Applications/Utilities/Adobe AIR Application Installer.app/Contents/MacOS/Adobe AIR Application Installer",
          args: ["-silent", "-location", unpack_dir, path],
        )
      end

      def dependencies
        @dependencies ||= [CaskLoader.load("adobe-air")]
      end
    end
  end
end
