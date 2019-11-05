# frozen_string_literal: true

module Zeitwerk
  class Inflector
    # Very basic snake case -> camel case conversion.
    #
    #   inflector = Zeitwerk::Inflector.new
    #   inflector.camelize("post", ...)             # => "Post"
    #   inflector.camelize("users_controller", ...) # => "UsersController"
    #   inflector.camelize("api", ...)              # => "Api"
    #
    # Takes into account hard-coded mappings configured with `inflect`.
    #
    # @param basename [String]
    # @param _abspath [String]
    # @return [String]
    def camelize(basename, _abspath)
      overrides[basename] || basename.split('_').map!(&:capitalize).join
    end

    # Configures hard-coded inflections:
    #
    #   inflector = Zeitwerk::Inflector.new
    #   inflector.inflect(
    #     "html_parser"   => "HTMLParser",
    #     "mysql_adapter" => "MySQLAdapter"
    #   )
    #
    #   inflector.camelize("html_parser", abspath)      # => "HTMLParser"
    #   inflector.camelize("mysql_adapter", abspath)    # => "MySQLAdapter"
    #   inflector.camelize("users_controller", abspath) # => "UsersController"
    #
    # @param inflections [{String => String}]
    # @return [void]
    def inflect(inflections)
      overrides.merge!(inflections)
    end

    private

    # Hard-coded basename to constant name user maps that override the default
    # inflection logic.
    #
    # @return [{String => String}]
    def overrides
      @overrides ||= {}
    end
  end
end
