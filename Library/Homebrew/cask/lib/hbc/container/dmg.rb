require "tempfile"

require "hbc/container/base"

module Hbc
  class Container
    class Dmg < Base
      def self.can_extract?(path:, magic_number:)
        imageinfo = system_command("/usr/bin/hdiutil",
                                   # realpath is a failsafe against unusual filenames
                                   args:         ["imageinfo", path.realpath],
                                   print_stderr: false).stdout

        !imageinfo.empty?
      end

      def extract_to_dir(unpack_dir, basename:, verbose:)
        mount(verbose: verbose) do |mounts|
          begin
            raise "No mounts found in '#{path}'; perhaps it is a bad disk image?" if mounts.empty?
            mounts.each do |mount|
              extract_mount(mount, to: unpack_dir)
            end
          ensure
            mounts.each(&method(:eject))
          end
        end
      end

      def mount(verbose: false)
        # realpath is a failsafe against unusual filenames
        realpath = path.realpath
        path = realpath

        Dir.mktmpdir do |unpack_dir|
          without_eula = system_command("/usr/bin/hdiutil",
                                        args:  ["attach", "-plist", "-nobrowse", "-readonly", "-noidme", "-mountrandom", unpack_dir, path],
                                        input: "qn\n",
                                        print_stderr: false)

          # If mounting without agreeing to EULA succeeded, there is none.
          plist = if without_eula.success?
            without_eula.plist
          else
            cdr_path = Pathname.new(unpack_dir).join("#{path.basename(".dmg")}.cdr")

            system_command!("/usr/bin/hdiutil", args: ["convert", "-quiet", "-format", "UDTO", "-o", cdr_path, path])

            with_eula = system_command!("/usr/bin/hdiutil",
                          args: ["attach", "-plist", "-nobrowse", "-readonly", "-noidme", "-mountrandom", unpack_dir, cdr_path])

            if verbose && !(eula_text = without_eula.stdout).empty?
              ohai "Software License Agreement for '#{path}':"
              puts eula_text
            end

            with_eula.plist
          end

          yield mounts_from_plist(plist)
        end
      end

      def eject(mount)
        # realpath is a failsafe against unusual filenames
        mountpath = Pathname.new(mount).realpath

        begin
          tries ||= 3

          return unless mountpath.exist?

          if tries > 1
            system_command!("/usr/sbin/diskutil",
                         args:         ["eject", mountpath],
                         print_stderr: false)
          else
            system_command!("/usr/sbin/diskutil",
                         args:         ["unmount", "force", mountpath],
                         print_stderr: false)
          end
        rescue ErrorDuringExecution => e
          raise e if (tries -= 1).zero?
          sleep 1
          retry
        end
      end

      private

      def extract_mount(mount, to:)
        Tempfile.open(["", ".bom"]) do |bomfile|
          bomfile.close

          Tempfile.open(["", ".list"]) do |filelist|
            filelist.puts(bom_filelist_from_path(mount))
            filelist.close

            system_command!("/usr/bin/mkbom", args: ["-s", "-i", filelist.path, "--", bomfile.path])
            system_command!("/usr/bin/ditto", args: ["--bom", bomfile.path, "--", mount, to])
          end
        end
      end

      def bom_filelist_from_path(mount)
        # We need to use `find` here instead of Ruby in order to properly handle
        # file names containing special characters, such as “e” + “´” vs. “é”.
        system_command("/usr/bin/find", args: [".", "-print0"], chdir: mount, print_stderr: false)
          .stdout
          .split("\0")
          .reject { |path| skip_path?(mount, path) }
          .join("\n")
      end

      def skip_path?(mount, path)
        path = Pathname(path.sub(%r{\A\./}, ""))
        dmg_metadata?(path) || system_dir_symlink?(mount, path)
      end

      # unnecessary DMG metadata
      DMG_METADATA_FILES = Set.new %w[
        .background
        .com.apple.timemachine.donotpresent
        .com.apple.timemachine.supported
        .DocumentRevisions-V100
        .DS_Store
        .fseventsd
        .MobileBackups
        .Spotlight-V100
        .TemporaryItems
        .Trashes
        .VolumeIcon.icns
      ].freeze

      def dmg_metadata?(path)
        relative_root = path.sub(%r{/.*}, "")
        DMG_METADATA_FILES.include?(relative_root.basename.to_s)
      end

      def system_dir_symlink?(mount, path)
        full_path = Pathname(mount).join(path)
        # symlinks to system directories (commonly to /Applications)
        full_path.symlink? && MacOS.system_dir?(full_path.readlink)
      end

      def mounts_from_plist(plist)
        return [] unless plist.respond_to?(:fetch)
        plist.fetch("system-entities", []).map { |e| e["mount-point"] }.compact
      end
    end
  end
end
