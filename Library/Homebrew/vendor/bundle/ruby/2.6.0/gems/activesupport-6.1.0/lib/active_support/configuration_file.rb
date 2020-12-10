# frozen_string_literal: true

module ActiveSupport
  # Reads a YAML configuration file, evaluating any ERB, then
  # parsing the resulting YAML.
  #
  # Warns in case of YAML confusing characters, like invisible
  # non-breaking spaces.
  class ConfigurationFile # :nodoc:
    class FormatError < StandardError; end

    def initialize(content_path)
      @content_path = content_path.to_s
      @content = read content_path
    end

    def self.parse(content_path, **options)
      new(content_path).parse(**options)
    end

    def parse(context: nil, **options)
      YAML.load(render(context), **options) || {}
    rescue Psych::SyntaxError => error
      raise "YAML syntax error occurred while parsing #{@content_path}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{error.message}"
    end

    private
      def read(content_path)
        require "yaml"
        require "erb"

        File.read(content_path).tap do |content|
          if content.include?("\u00A0")
            warn "File contains invisible non-breaking spaces, you may want to remove those"
          end
        end
      end

      def render(context)
        erb = ERB.new(@content).tap { |e| e.filename = @content_path }
        context ? erb.result(context) : erb.result
      end
  end
end
