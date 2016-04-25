require "hardware"
require "os/mac/version"
require "os/mac/xcode"
require "os/mac/xquartz"
require "os/mac/pathname"
require "os/mac/sdk"
require "os/mac/keg"

module OS
  module Mac
    extend self

    ::MacOS = self # compatibility

    raise "Loaded OS::Mac on generic OS!" if ENV["HOMEBREW_TEST_GENERIC_OS"]

    # This can be compared to numerics, strings, or symbols
    # using the standard Ruby Comparable methods.
    def version
      @version ||= Version.new(full_version.to_s[/10\.\d+/])
    end

    # This can be compared to numerics, strings, or symbols
    # using the standard Ruby Comparable methods.
    def full_version
      @full_version ||= Version.new(ENV["HOMEBREW_OSX_VERSION"].chomp)
    end

    def prerelease?
      # TODO: bump version when new OS is released
      version >= "10.12"
    end

    def outdated_release?
      # TODO: bump version when new OS is released
      version < "10.9"
    end

    def cat
      version.to_sym
    end

    def locate(tool)
      # Don't call tools (cc, make, strip, etc.) directly!
      # Give the name of the binary you look for as a string to this method
      # in order to get the full path back as a Pathname.
      (@locate ||= {}).fetch(tool) do |key|
        @locate[key] = if File.executable?(path = "/usr/bin/#{tool}")
          Pathname.new path
        # Homebrew GCCs most frequently; much faster to check this before xcrun
        elsif (path = HOMEBREW_PREFIX/"bin/#{tool}").executable?
          path
        # xcrun was introduced in Xcode 3 on Leopard
        elsif MacOS.version > :tiger
          path = Utils.popen_read("/usr/bin/xcrun", "-no-cache", "-find", tool).chomp
          Pathname.new(path) if File.executable?(path)
        end
      end
    end

    # Locates a (working) copy of install_name_tool, guaranteed to function
    # whether the user has developer tools installed or not.
    def install_name_tool
      if (path = HOMEBREW_PREFIX/"opt/cctools/bin/install_name_tool").executable?
        path
      else
        locate("install_name_tool")
      end
    end

    # Locates a (working) copy of otool, guaranteed to function whether the user
    # has developer tools installed or not.
    def otool
      if (path = HOMEBREW_PREFIX/"opt/cctools/bin/otool").executable?
        path
      else
        locate("otool")
      end
    end

    # Checks if the user has any developer tools installed, either via Xcode
    # or the CLT. Convenient for guarding against formula builds when building
    # is impossible.
    def has_apple_developer_tools?
      Xcode.installed? || CLT.installed?
    end

    def active_developer_dir
      @active_developer_dir ||= Utils.popen_read("/usr/bin/xcode-select", "-print-path").strip
    end

    # If a specific SDK is requested
    #   a) The requested SDK is returned, if it's installed.
    #   b) If the requested SDK is not installed, the newest SDK (if any SDKs
    #      are available) is returned.
    #   c) If no SDKs are available, nil is returned.
    # If no specific SDK is requested
    #   a) For Xcode >= 7, the latest SDK is returned even if the latest SDK is
    #      named after a newer OS version than the running OS. The
    #      MACOSX_DEPLOYMENT_TARGET must be set to the OS for which you're
    #      actually building (usually the running OS version).
    #      https://github.com/Homebrew/legacy-homebrew/pull/50355
    #      https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/WhatsNewXcode/Articles/Introduction.html#//apple_ref/doc/uid/TP40004626
    #      Section "About SDKs and Simulator"
    #   b) For Xcode < 7, proceed as if the SDK for the running OS version had
    #      specifically been requested according to the rules above.

    def sdk(v = nil)
      @locator ||= SDKLocator.new
      begin
        sdk = if v.nil?
          Xcode.version.to_i >= 7 ? @locator.latest_sdk : @locator.sdk_for(version)
        else
          @locator.sdk_for v
        end
      rescue SDKLocator::NoSDKError
        sdk = @locator.latest_sdk
      end
      # Only return an SDK older than the OS version if it was specifically requested
      sdk if v || (!sdk.nil? && sdk.version >= version)
    end

    # Returns the path to an SDK or nil, following the rules set by #sdk.
    def sdk_path(v = nil)
      s = sdk(v)
      s.path unless s.nil?
    end

    def default_cc
      cc = locate "cc"
      cc.realpath.basename.to_s rescue nil
    end

    def default_compiler
      case default_cc
      # if GCC 4.2 is installed, e.g. via Tigerbrew, prefer it
      # over the system's GCC 4.0
      when /^gcc-4.0/ then gcc_42_build_version ? :gcc : :gcc_4_0
      when /^gcc/ then :gcc
      when /^llvm/ then :llvm
      when "clang" then :clang
      else
        # guess :(
        if Xcode.version >= "4.3"
          :clang
        elsif Xcode.version >= "4.2"
          :llvm
        else
          :gcc
        end
      end
    end

    def gcc_40_build_version
      @gcc_40_build_version ||=
        if (path = locate("gcc-4.0"))
          `#{path} --version 2>/dev/null`[/build (\d{4,})/, 1].to_i
        end
    end
    alias_method :gcc_4_0_build_version, :gcc_40_build_version

    def gcc_42_build_version
      @gcc_42_build_version ||=
        begin
          gcc = MacOS.locate("gcc-4.2") || HOMEBREW_PREFIX.join("opt/apple-gcc42/bin/gcc-4.2")
          if gcc.exist? && !gcc.realpath.basename.to_s.start_with?("llvm")
            `#{gcc} --version 2>/dev/null`[/build (\d{4,})/, 1].to_i
          end
        end
    end
    alias_method :gcc_build_version, :gcc_42_build_version

    def llvm_build_version
      @llvm_build_version ||=
        if (path = locate("llvm-gcc")) && !path.realpath.basename.to_s.start_with?("clang")
          `#{path} --version`[/LLVM build (\d{4,})/, 1].to_i
        end
    end

    def clang_version
      @clang_version ||=
        if (path = locate("clang"))
          `#{path} --version`[/(?:clang|LLVM) version (\d\.\d)/, 1]
        end
    end

    def clang_build_version
      @clang_build_version ||=
        if (path = locate("clang"))
          `#{path} --version`[/clang-(\d{2,})/, 1].to_i
        end
    end

    def non_apple_gcc_version(cc)
      (@non_apple_gcc_version ||= {}).fetch(cc) do
        path = HOMEBREW_PREFIX.join("opt", "gcc", "bin", cc)
        path = locate(cc) unless path.exist?
        version = `#{path} --version`[/gcc(?:-\d(?:\.\d)? \(.+\))? (\d\.\d\.\d)/, 1] if path
        @non_apple_gcc_version[cc] = version
      end
    end

    def clear_version_cache
      @gcc_40_build_version = @gcc_42_build_version = @llvm_build_version = nil
      @clang_version = @clang_build_version = nil
      @non_apple_gcc_version = {}
    end

    # See these issues for some history:
    # https://github.com/Homebrew/legacy-homebrew/issues/13
    # https://github.com/Homebrew/legacy-homebrew/issues/41
    # https://github.com/Homebrew/legacy-homebrew/issues/48
    def macports_or_fink
      paths = []

      # First look in the path because MacPorts is relocatable and Fink
      # may become relocatable in the future.
      %w[port fink].each do |ponk|
        path = which(ponk)
        paths << path unless path.nil?
      end

      # Look in the standard locations, because even if port or fink are
      # not in the path they can still break builds if the build scripts
      # have these paths baked in.
      %w[/sw/bin/fink /opt/local/bin/port].each do |ponk|
        path = Pathname.new(ponk)
        paths << path if path.exist?
      end

      # Finally, some users make their MacPorts or Fink directorie
      # read-only in order to try out Homebrew, but this doens't work as
      # some build scripts error out when trying to read from these now
      # unreadable paths.
      %w[/sw /opt/local].map { |p| Pathname.new(p) }.each do |path|
        paths << path if path.exist? && !path.readable?
      end

      paths.uniq
    end

    def prefer_64_bit?
      if ENV["HOMEBREW_PREFER_64_BIT"] && version == :leopard
        Hardware::CPU.is_64_bit?
      else
        Hardware::CPU.is_64_bit? && version > :leopard
      end
    end

    def preferred_arch
      if prefer_64_bit?
        Hardware::CPU.arch_64_bit
      else
        Hardware::CPU.arch_32_bit
      end
    end

    STANDARD_COMPILERS = {
      "2.0"   => { :gcc_40_build => 4061 },
      "2.5"   => { :gcc_40_build => 5370 },
      "3.1.4" => { :gcc_40_build => 5493, :gcc_42_build => 5577 },
      "3.2.6" => { :gcc_40_build => 5494, :gcc_42_build => 5666, :llvm_build => 2335, :clang => "1.7", :clang_build => 77 },
      "4.0"   => { :gcc_40_build => 5494, :gcc_42_build => 5666, :llvm_build => 2335, :clang => "2.0", :clang_build => 137 },
      "4.0.1" => { :gcc_40_build => 5494, :gcc_42_build => 5666, :llvm_build => 2335, :clang => "2.0", :clang_build => 137 },
      "4.0.2" => { :gcc_40_build => 5494, :gcc_42_build => 5666, :llvm_build => 2335, :clang => "2.0", :clang_build => 137 },
      "4.2"   => { :llvm_build => 2336, :clang => "3.0", :clang_build => 211 },
      "4.3"   => { :llvm_build => 2336, :clang => "3.1", :clang_build => 318 },
      "4.3.1" => { :llvm_build => 2336, :clang => "3.1", :clang_build => 318 },
      "4.3.2" => { :llvm_build => 2336, :clang => "3.1", :clang_build => 318 },
      "4.3.3" => { :llvm_build => 2336, :clang => "3.1", :clang_build => 318 },
      "4.4"   => { :llvm_build => 2336, :clang => "4.0", :clang_build => 421 },
      "4.4.1" => { :llvm_build => 2336, :clang => "4.0", :clang_build => 421 },
      "4.5"   => { :llvm_build => 2336, :clang => "4.1", :clang_build => 421 },
      "4.5.1" => { :llvm_build => 2336, :clang => "4.1", :clang_build => 421 },
      "4.5.2" => { :llvm_build => 2336, :clang => "4.1", :clang_build => 421 },
      "4.6"   => { :llvm_build => 2336, :clang => "4.2", :clang_build => 425 },
      "4.6.1" => { :llvm_build => 2336, :clang => "4.2", :clang_build => 425 },
      "4.6.2" => { :llvm_build => 2336, :clang => "4.2", :clang_build => 425 },
      "4.6.3" => { :llvm_build => 2336, :clang => "4.2", :clang_build => 425 },
      "5.0"   => { :clang => "5.0", :clang_build => 500 },
      "5.0.1" => { :clang => "5.0", :clang_build => 500 },
      "5.0.2" => { :clang => "5.0", :clang_build => 500 },
      "5.1"   => { :clang => "5.1", :clang_build => 503 },
      "5.1.1" => { :clang => "5.1", :clang_build => 503 },
      "6.0"   => { :clang => "6.0", :clang_build => 600 },
      "6.0.1" => { :clang => "6.0", :clang_build => 600 },
      "6.1"   => { :clang => "6.0", :clang_build => 600 },
      "6.1.1" => { :clang => "6.0", :clang_build => 600 },
      "6.2"   => { :clang => "6.0", :clang_build => 600 },
      "6.3"   => { :clang => "6.1", :clang_build => 602 },
      "6.3.1" => { :clang => "6.1", :clang_build => 602 },
      "6.3.2" => { :clang => "6.1", :clang_build => 602 },
      "6.4"   => { :clang => "6.1", :clang_build => 602 },
      "7.0"   => { :clang => "7.0", :clang_build => 700 },
      "7.0.1" => { :clang => "7.0", :clang_build => 700 },
      "7.1"   => { :clang => "7.0", :clang_build => 700 },
      "7.1.1" => { :clang => "7.0", :clang_build => 700 },
      "7.2"   => { :clang => "7.0", :clang_build => 700 },
      "7.2.1" => { :clang => "7.0", :clang_build => 700 },
      "7.3"   => { :clang => "7.3", :clang_build => 703 },
      "7.3.1" => { :clang => "7.3", :clang_build => 703 },
    }

    def compilers_standard?
      STANDARD_COMPILERS.fetch(Xcode.version.to_s).all? do |method, build|
        send(:"#{method}_version") == build
      end
    rescue IndexError
      onoe <<-EOS.undent
        Homebrew doesn't know what compiler versions ship with your version
        of Xcode (#{Xcode.version}). Please `brew update` and if that doesn't
        help, file an issue with the output of `brew --config`:
          https://github.com/Homebrew/brew/issues

        Note that we only track stable, released versions of Xcode.

        Thanks!
      EOS
    end

    def app_with_bundle_id(*ids)
      path = mdfind(*ids).first
      Pathname.new(path) unless path.nil? || path.empty?
    end

    def mdfind(*ids)
      return [] unless OS.mac?
      (@mdfind ||= {}).fetch(ids) do
        @mdfind[ids] = Utils.popen_read("/usr/bin/mdfind", mdfind_query(*ids)).split("\n")
      end
    end

    def pkgutil_info(id)
      (@pkginfo ||= {}).fetch(id) do |key|
        @pkginfo[key] = Utils.popen_read("/usr/sbin/pkgutil", "--pkg-info", key).strip
      end
    end

    def mdfind_query(*ids)
      ids.map! { |id| "kMDItemCFBundleIdentifier == #{id}" }.join(" || ")
    end
  end
end
