module Hbc
  class CLI
    class Create < AbstractCommand
      def self.run(*args)
        new(*args).run
      end

      def run
        cask_tokens = self.class.cask_tokens_from(@args)
        raise CaskUnspecifiedError if cask_tokens.empty?
        cask_token = cask_tokens.first.sub(/\.rb$/i, "")
        cask_path = CaskLoader.path(cask_token)
        odebug "Creating Cask #{cask_token}"

        raise CaskAlreadyCreatedError, cask_token if cask_path.exist?

        File.open(cask_path, "w") do |f|
          f.write self.class.template(cask_token)
        end

        exec_editor cask_path
      end

      def self.template(cask_token)
        <<-EOS.undent
          cask '#{cask_token}' do
            version ''
            sha256 ''

            url 'https://'
            name ''
            homepage ''

            app ''
          end
        EOS
      end

      def self.help
        "creates the given Cask and opens it in an editor"
      end
    end
  end
end
