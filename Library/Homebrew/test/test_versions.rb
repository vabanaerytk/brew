require 'testing_env'
require 'formula'
require 'test/testball'
require 'version'

module VersionAssertions
  def assert_version url, version
    assert_equal version, Version.parse(url).to_s
  end

  def assert_version_nil url
    assert_nil Version.parse(url)
  end

  def assert_comparison a, comparison, b
    eval "assert Version.new(a) #{comparison} Version.new(b)"
  end
end

class TestBadVersion < TestBall
  def initialize name=nil
    @stable = SoftwareSpec.new
    @stable.version "versions can't have spaces"
    super 'testbadversion'
  end
end

class VersionComparisonTests < Test::Unit::TestCase
  include VersionAssertions

  def test_version_comparisons
    assert_comparison '0.1', '==', '0.1.0'
    assert_comparison '0.1', '!=', '0.2'
    assert_comparison '1.2.3', '>', '1.2.2'
    assert_comparison '1.2.3-p34', '>', '1.2.3-p33'
    assert_comparison '1.2.4', '<', '1.2.4.1'
  end
end

class VersionParsingTests < Test::Unit::TestCase
  include VersionAssertions

  def test_pathname_version
    d = HOMEBREW_CELLAR/'foo-0.1.9'
    d.mkpath
    assert_equal '0.1.9', d.version
  end

  def test_no_version
    assert_version_nil 'http://example.com/blah.tar'
    assert_version_nil 'foo'
  end

  def test_bad_version
    assert_raises(RuntimeError) { f = TestBadVersion.new }
  end

  def test_version_all_dots
    assert_version 'http://example.com/foo.bar.la.1.14.zip', '1.14'
  end

  def test_version_underscore_separator
    assert_version 'http://example.com/grc_1.1.tar.gz', '1.1'
  end

  def test_boost_version_style
    assert_version 'http://example.com/boost_1_39_0.tar.bz2', '1.39.0'
  end

  def test_erlang_version_style
    assert_version 'http://erlang.org/download/otp_src_R13B.tar.gz', 'R13B'
  end

  def test_p7zip_version_style
    assert_version 'http://kent.dl.sourceforge.net/sourceforge/p7zip/p7zip_9.04_src_all.tar.bz2',
      '9.04'
  end

  def test_new_github_style
    assert_version 'https://github.com/sam-github/libnet/tarball/libnet-1.1.4', '1.1.4'
  end

  def test_gloox_beta_style
    assert_version 'http://camaya.net/download/gloox-1.0-beta7.tar.bz2', '1.0-beta7'
  end

  def test_sphinx_beta_style
    assert_version 'http://sphinxsearch.com/downloads/sphinx-1.10-beta.tar.gz', '1.10-beta'
  end

  def test_astyle_verson_style
    assert_version 'http://kent.dl.sourceforge.net/sourceforge/astyle/astyle_1.23_macosx.tar.gz',
      '1.23'
  end

  def test_version_dos2unix
    assert_version 'http://www.sfr-fresh.com/linux/misc/dos2unix-3.1.tar.gz', '3.1'
  end

  def test_version_internal_dash
    assert_version 'http://example.com/foo-arse-1.1-2.tar.gz', '1.1-2'
  end

  def test_version_single_digit
    assert_version 'http://example.com/foo_bar.45.tar.gz', '45'
  end

  def test_noseparator_single_digit
    assert_version 'http://example.com/foo_bar45.tar.gz', '45'
  end

  def test_version_developer_that_hates_us_format
    assert_version 'http://example.com/foo-bar-la.1.2.3.tar.gz', '1.2.3'
  end

  def test_version_regular
    assert_version 'http://example.com/foo_bar-1.21.tar.gz', '1.21'
  end

  def test_version_sourceforge_download
    assert_version 'http://sourceforge.net/foo_bar-1.21.tar.gz/download', '1.21'
    assert_version 'http://sf.net/foo_bar-1.21.tar.gz/download', '1.21'
  end

  def test_version_github
    assert_version 'http://github.com/lloyd/yajl/tarball/1.0.5', '1.0.5'
  end

  def test_version_github_with_high_patch_number
    assert_version 'http://github.com/lloyd/yajl/tarball/v1.2.34', '1.2.34'
  end

  def test_yet_another_version
    assert_version 'http://example.com/mad-0.15.1b.tar.gz', '0.15.1b'
  end

  def test_lame_version_style
    assert_version 'http://kent.dl.sourceforge.net/sourceforge/lame/lame-398-2.tar.gz',
      '398-2'
  end

  def test_ruby_version_style
    assert_version 'ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz',
      '1.9.1-p243'
  end

  def test_omega_version_style
    assert_version 'http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz',
      '0.80.2'
  end

  def test_rc_style
    assert_version 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.2rc1.tar.bz2',
      '1.2.2rc1'
  end

  def test_dash_rc_style
    assert_version 'http://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz',
      '1.8.0-rc1'
  end

  def test_angband_version_style
    assert_version 'http://rephial.org/downloads/3.0/angband-3.0.9b-src.tar.gz',
      '3.0.9b'
  end

  def test_stable_suffix
    assert_version 'http://www.monkey.org/~provos/libevent-1.4.14b-stable.tar.gz',
      '1.4.14b'
  end

  def test_debian_style_1
    assert_version 'http://ftp.de.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz',
      '3.03'
  end

  def test_debian_style_2
    assert_version 'http://ftp.de.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz',
      '1.01b'
  end

  def test_bottle_style
    assert_version 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.8.0.lion.bottle.tar.gz',
      '4.8.0'
  end

  def test_versioned_bottle_style
    assert_version 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.8.1.lion.bottle.1.tar.gz',
      '4.8.1'
  end

  def test_erlang_bottle_style
    assert_version 'https://downloads.sf.net/project/machomebrew/Bottles/erlang-R15B.lion.bottle.tar.gz',
      'R15B'
  end

  def test_old_bottle_style
    assert_version 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.7.3-bottle.tar.gz',
      '4.7.3'
  end

  def test_old_erlang_bottle_style
    assert_version 'https://downloads.sf.net/project/machomebrew/Bottles/erlang-R15B-bottle.tar.gz',
      'R15B'
  end

  def test_imagemagick_style
    assert_version 'http://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.7.5-7.tar.bz2',
      '6.7.5-7'
  end

  def test_imagemagick_bottle_style
    assert_version 'https://downloads.sf.net/project/machomebrew/Bottles/imagemagick-6.7.5-7.lion.bottle.tar.gz',
      '6.7.5-7'
  end

  def test_imagemagick_versioned_bottle_style
    assert_version 'https://downloads.sf.net/project/machomebrew/Bottles/imagemagick-6.7.5-7.lion.bottle.1.tar.gz',
      '6.7.5-7'
  end

  def test_dash_version_dash_style
    assert_version 'http://www.antlr.org/download/antlr-3.4-complete.jar', '3.4'
  end

  # def test_version_ghc_style
  #   assert_version 'http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-x86_64-apple-darwin.tar.bz2', '7.0.4'
  #   assert_version 'http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-i386-apple-darwin.tar.bz2', '7.0.4'
  # end

  def test_more_versions
    assert_version 'http://pypy.org/download/pypy-1.4.1-osx.tar.bz2', '1.4.1'
    assert_version 'http://www.openssl.org/source/openssl-0.9.8s.tar.gz', '0.9.8s'
    assert_version 'ftp://ftp.visi.com/users/hawkeyd/X/Xaw3d-1.5E.tar.gz', '1.5E'
    assert_version 'http://downloads.sourceforge.net/project/assimp/assimp-2.0/assimp--2.0.863-sdk.zip',
      '2.0.863'
    assert_version 'http://common-lisp.net/project/cmucl/downloads/release/20c/cmucl-20c-x86-darwin.tar.bz2',
      '20c'
    assert_version 'http://downloads.sourceforge.net/project/fann/fann/2.1.0beta/fann-2.1.0beta.zip',
      '2.1.0beta'
    assert_version 'ftp://iges.org/grads/2.0/grads-2.0.1-bin-darwin9.8-intel.tar.gz', '2.0.1'
    assert_version 'http://haxe.org/file/haxe-2.08-osx.tar.gz', '2.08'
    assert_version 'ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz', '2007f'
    assert_version 'http://sourceforge.net/projects/x3270/files/x3270/3.3.12ga7/suite3270-3.3.12ga7-src.tgz',
      '3.3.12ga7'
    assert_version 'http://www.gedanken.demon.co.uk/download-wwwoffle/wwwoffle-2.9h.tgz', '2.9h'
    assert_version 'http://synergy.googlecode.com/files/synergy-1.3.6p2-MacOSX-Universal.zip', '1.3.6p2'
  end
end
