module Hbc
  class CLI
    class Home < Base
      def self.run(*cask_tokens)
        if cask_tokens.empty?
          odebug "Opening project homepage"
          system "/usr/bin/open", "--", "https://caskroom.github.io/"
        else
          cask_tokens.each do |cask_token|
            odebug "Opening homepage for Cask #{cask_token}"
            cask = CaskLoader.load(cask_token)
            system "/usr/bin/open", "--", cask.homepage
          end
        end
      end

      def self.help
        "opens the homepage of the given Cask"
      end
    end
  end
end
