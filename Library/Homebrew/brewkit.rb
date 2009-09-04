#  Copyright 2009 Max Howell and other contributors.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
require 'fileutils'
require 'formula'
require 'download_strategy'
require 'hardware'

# TODO
# 1. Indeed, there should be an option to build 32 or 64 bit binaries
# 2. Homebrew will not support building 32 and 64 bit lipo'd binaries, I
#    want to, but the simple fact is it is difficult to force most of the
#    build systems we support to do it.


`/usr/bin/sw_vers -productVersion` =~ /(10\.\d+)(\.\d+)?/
MACOS_VERSION=$1.to_f
ENV['MACOSX_DEPLOYMENT_TARGET']=$1

# ignore existing build vars, thus we should have less bugs to deal with
ENV['LDFLAGS']=""

cflags=%w[-O3]

# optimise all the way to eleven, references:
# http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel
# http://forums.mozillazine.org/viewtopic.php?f=12&t=577299
# http://gcc.gnu.org/onlinedocs/gcc-4.2.1/gcc/i386-and-x86_002d64-Options.html
if MACOS_VERSION >= 10.6
  case Hardware.intel_family
  when :penryn, :core2
    # no need to add -mfpmath when you specify -m64
    cflags<<"-march=core2"<<'-m64'
    ENV['LDFLAGS']="-arch x86_64"
  when :core
    cflags<<"-march=prescott"<<"-mfpmath=sse"
  end
else
  case Hardware.intel_family
  when :penryn, :core2
    cflags<<"-march=nocona"
  when :core
    cflags<<"-march=prescott"
  end
  cflags<<"-mfpmath=sse"
  
  # use gcc 4.2 if available (Xcode 3.1 and above)
  if system "which -s gcc-4.2" and $?.success?
    ENV['CC']="gcc-4.2"
    ENV['CXX']="g++-4.2"
  end
end

cflags<<"-mmmx"
case Hardware.intel_family
when :penryn
  cflags<<"-msse4.1"
when :core2, :core
  cflags<<"-msse3"
end

# -w: keep signal to noise high
# -fomit-frame-pointer: we are not debugging this software, we are using it
ENV['CFLAGS']=ENV['CXXFLAGS']="#{cflags*' '} -w -pipe -fomit-frame-pointer -mmacosx-version-min=#{MACOS_VERSION}"

# compile faster
ENV['MAKEFLAGS']="-j#{Hardware.processor_count}"

# /usr/local is always in the build system path
unless HOMEBREW_PREFIX.to_s == '/usr/local'
  ENV['CPPFLAGS']="-I#{HOMEBREW_PREFIX}/include"
  ENV['LDFLAGS']="-L#{HOMEBREW_PREFIX}/lib"
end


# you can use these functions for packages that have build issues
module HomebrewEnvExtension
  def deparallelize
    remove 'MAKEFLAGS', /-j\d+/
  end
  alias_method :j1, :deparallelize
  def gcc_4_0_1
    case MACOS_VERSION
    when 10.5
      self['CC']=nil
      self['CXX']=nil
    when 10.6..11.0
      self['CC']='gcc-4.0'
      self['CXX']='g++-4.0'
      remove_from_cflags '-march=core2' # we *should* add back in stuff but meh for now
    end
  end
  def osx_10_4
    self['MACOSX_DEPLOYMENT_TARGET']=nil
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
  end
  def generic_i386
     %w[-mfpmath=sse -msse3 -mmmx -march=\w+].each {|s| remove_from_cflags s}
  end
  def libxml2
    append_to_cflags ' -I/usr/include/libxml2'
  end
  # TODO rename or alias to x11
  def libpng
    # CPPFLAGS are the C-PreProcessor flags, *not* C++!
    append 'CPPFLAGS', '-I/usr/X11R6/include'
    append 'LDFLAGS', '-L/usr/X11R6/lib'
  end
  # we've seen some packages fail to build when warnings are disabled!
  def enable_warnings
    remove_from_cflags '-w'
  end

private
  def append key, value
    ref=self[key]
    if ref.nil? or ref.empty?
      self[key]=value
    else
      self[key]=ref+' '+value
    end
  end
  def append_to_cflags f
    append 'CFLAGS', f
    append 'CXXFLAGS', f
  end
  def remove key, value
    return if self[key].nil?
    self[key]=self[key].sub value, '' # can't use sub! on ENV
    self[key]=nil if self[key].empty? # keep things clean
  end
  def remove_from_cflags f
    remove 'CFLAGS', f
    remove 'CXXFLAGS', f
  end
end

ENV.extend HomebrewEnvExtension


# remove MacPorts and Fink from the PATH, this prevents issues like:
# http://github.com/mxcl/homebrew/issues/#issue/13
paths=ENV['PATH'].split(':').reject do |p|
  p.squeeze! '/'
  p =~ %r[^/opt/local] or p =~ %r[^/sw]
end
ENV['PATH']=paths*':'


def inreplace(path, before, after)
  before=Regexp.escape before.to_s
  before.gsub! "/", "\\/" # I guess not escaped as delimiter varies
  after=after.to_s
  after.gsub! "\\", "\\\\"
  after.gsub! "/", "\\/"

  # FIXME use proper Ruby for teh exceptions!
  safe_system "perl", "-pi", "-e", "s/#{before}/#{after}/g", path
end
