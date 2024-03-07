# typed: true
# frozen_string_literal: true

module Homebrew
  module Install
    # This is a list of known paths to the host dynamic linker on Linux if
    # the host glibc is new enough.  The symlink_ld_so method will fail if
    # the host linker cannot be found in this list.
    DYNAMIC_LINKERS = %w[
      /lib64/ld-linux-x86-64.so.2
      /lib64/ld64.so.2
      /lib/ld-linux.so.3
      /lib/ld-linux.so.2
      /lib/ld-linux-aarch64.so.1
      /lib/ld-linux-armhf.so.3
      /system/bin/linker64
      /system/bin/linker
    ].freeze
    private_constant :DYNAMIC_LINKERS

    # We link GCC runtime libraries that are not specifically used for Fortran,
    # which are linked by the GCC formula.  We only use the versioned shared libraries
    # as the other shared and static libraries are only used at build time where
    # GCC can find its own libraries.
    GCC_RUNTIME_LIBS = %w[
      libatomic.so.1
      libgcc_s.so.1
      libgomp.so.1
      libstdc++.so.6
    ].freeze
    private_constant :GCC_RUNTIME_LIBS

    def self.perform_preinstall_checks(all_fatal: false, cc: nil)
      generic_perform_preinstall_checks(all_fatal:, cc:)
      symlink_ld_so
      setup_preferred_gcc_libs
    end

    def self.global_post_install
      generic_global_post_install
      symlink_ld_so
      setup_preferred_gcc_libs
    end

    def self.check_cpu
      return if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      return if Hardware::CPU.arm?

      message = "Sorry, Homebrew does not support your computer's CPU architecture!"
      if Hardware::CPU.ppc64le?
        message += <<~EOS
          For OpenPOWER Linux (PPC64LE) support, see:
            #{Formatter.url("https://github.com/homebrew-ppc64le/brew")}
        EOS
      end
      abort message
    end
    private_class_method :check_cpu

    def self.symlink_ld_so
      brew_ld_so = HOMEBREW_PREFIX/"lib/ld.so"

      ld_so = HOMEBREW_PREFIX/"opt/glibc/bin/ld.so"
      unless ld_so.readable?
        ld_so = DYNAMIC_LINKERS.find { |s| File.executable? s }
        if ld_so.blank?
          raise "Unable to locate the system's dynamic linker" unless brew_ld_so.readable?

          return
        end
      end

      return if brew_ld_so.readable? && (brew_ld_so.readlink == ld_so)

      FileUtils.mkdir_p HOMEBREW_PREFIX/"lib"
      FileUtils.ln_sf ld_so, brew_ld_so
    end
    private_class_method :symlink_ld_so

    def self.setup_preferred_gcc_libs
      gcc_opt_prefix = HOMEBREW_PREFIX/"opt/#{OS::LINUX_PREFERRED_GCC_RUNTIME_FORMULA}"
      glibc_installed = (HOMEBREW_PREFIX/"opt/glibc/bin/ld.so").readable?

      return unless gcc_opt_prefix.readable?

      if glibc_installed
        ld_so_conf_d = HOMEBREW_PREFIX/"etc/ld.so.conf.d"
        unless ld_so_conf_d.exist?
          ld_so_conf_d.mkpath
          FileUtils.chmod "go-w", ld_so_conf_d
        end

        # Add gcc to ld search paths
        ld_gcc_conf = ld_so_conf_d/"50-homebrew-preferred-gcc.conf"
        ld_gcc_conf_content = <<~EOS
          # This file is generated by Homebrew. Do not modify.
          #{gcc_opt_prefix}/lib/gcc/current
        EOS

        if !ld_gcc_conf.exist? || (ld_gcc_conf.read != ld_gcc_conf_content)
          ld_gcc_conf.atomic_write ld_gcc_conf_content
          FileUtils.chmod "u=rw,go-wx", ld_gcc_conf

          FileUtils.rm_f HOMEBREW_PREFIX/"etc/ld.so.cache"
          system HOMEBREW_PREFIX/"opt/glibc/sbin/ldconfig"
        end
      else
        odie "#{HOMEBREW_PREFIX}/lib does not exist!" unless (HOMEBREW_PREFIX/"lib").readable?
      end

      GCC_RUNTIME_LIBS.each do |library|
        gcc_library_symlink = HOMEBREW_PREFIX/"lib/#{library}"

        if glibc_installed
          # Remove legacy symlinks
          FileUtils.rm gcc_library_symlink if gcc_library_symlink.symlink?
        else
          gcc_library = gcc_opt_prefix/"lib/gcc/current/#{library}"
          # Skip if the link target doesn't exist.
          next unless gcc_library.readable?

          # Also skip if the symlink already exists.
          next if gcc_library_symlink.readable? && (gcc_library_symlink.readlink == gcc_library)

          FileUtils.ln_sf gcc_library, gcc_library_symlink
        end
      end
    end
    private_class_method :setup_preferred_gcc_libs
  end
end
