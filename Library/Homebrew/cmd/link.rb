module Homebrew extend self
  def link
    ARGV.kegs.each do |keg|
      print "Linking #{keg}... "
      puts "#{keg.link} symlinks created"
    end
  end
end
