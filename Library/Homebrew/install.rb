require "diagnostic"
require "fileutils"
require "hardware"
require "development_tools"

module Homebrew
  module Install
    module_function

    def check_ppc
      case Hardware::CPU.type
      when :ppc
        abort <<~EOS
          Sorry, Homebrew does not support your computer's CPU architecture.
          For PPC support, see: https://github.com/mistydemeo/tigerbrew
        EOS
      end
    end

    def attempt_directory_creation
      Keg::MUST_BE_WRITABLE_DIRECTORIES.each do |dir|
        begin
          FileUtils.mkdir_p(dir) unless dir.exist?
        rescue
          nil
        end
      end
    end

    def perform_development_tools_checks
      fatal_checks(:fatal_development_tools_checks)
    end

    def perform_preinstall_checks
      check_ppc
      attempt_directory_creation
      fatal_checks(:fatal_install_checks)
    end

    def fatal_checks(type)
      @checks ||= Diagnostic::Checks.new
      failed = false
      @checks.public_send(type).each do |check|
        out = @checks.public_send(check)
        next if out.nil?

        failed ||= true
        ofail out
      end
      exit 1 if failed
    end
  end
end
