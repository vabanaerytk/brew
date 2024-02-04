# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `yard-sorbet` gem.
# Please instead update this file by running `bin/tapioca gem yard-sorbet`.

class YARD::Handlers::Ruby::ClassHandler < ::YARD::Handlers::Ruby::Base
  include ::YARDSorbet::Handlers::StructClassHandler
end

# Types are documentation
#
# source://yard-sorbet//lib/yard-sorbet/version.rb#5
module YARDSorbet; end

# Extract & re-add directives to a docstring
#
# source://yard-sorbet//lib/yard-sorbet/directives.rb#6
module YARDSorbet::Directives
  class << self
    # source://yard-sorbet//lib/yard-sorbet/directives.rb#21
    sig { params(docstring: ::String, directives: T::Array[::String]).void }
    def add_directives(docstring, directives); end

    # source://yard-sorbet//lib/yard-sorbet/directives.rb#10
    sig { params(docstring: T.nilable(::String)).returns([::YARD::Docstring, T::Array[::String]]) }
    def extract_directives(docstring); end
  end
end

# Custom YARD Handlers
#
# @see https://rubydoc.info/gems/yard/YARD/Handlers/Base YARD Base Handler documentation
#
# source://yard-sorbet//lib/yard-sorbet/handlers.rb#7
module YARDSorbet::Handlers; end

# Apllies an `@abstract` tag to `abstract!`/`interface!` modules (if not alerady present).
#
# source://yard-sorbet//lib/yard-sorbet/handlers/abstract_dsl_handler.rb#7
class YARDSorbet::Handlers::AbstractDSLHandler < ::YARD::Handlers::Ruby::Base
  # source://yard-sorbet//lib/yard-sorbet/handlers/abstract_dsl_handler.rb#21
  sig { void }
  def process; end
end

# Extra text for class namespaces
#
# source://yard-sorbet//lib/yard-sorbet/handlers/abstract_dsl_handler.rb#18
YARDSorbet::Handlers::AbstractDSLHandler::CLASS_TAG_TEXT = T.let(T.unsafe(nil), String)

# The text accompanying the `@abstract` tag.
#
# @see https://github.com/lsegal/yard/blob/main/templates/default/docstring/html/abstract.erb The `@abstract` tag template
#
# source://yard-sorbet//lib/yard-sorbet/handlers/abstract_dsl_handler.rb#16
YARDSorbet::Handlers::AbstractDSLHandler::TAG_TEXT = T.let(T.unsafe(nil), String)

# Handle `enums` calls, registering enum values as constants
#
# source://yard-sorbet//lib/yard-sorbet/handlers/enums_handler.rb#7
class YARDSorbet::Handlers::EnumsHandler < ::YARD::Handlers::Ruby::Base
  # source://yard-sorbet//lib/yard-sorbet/handlers/enums_handler.rb#14
  sig { void }
  def process; end

  private

  # source://yard-sorbet//lib/yard-sorbet/handlers/enums_handler.rb#29
  sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Boolean) }
  def const_assign_node?(node); end
end

# Extends any modules included via `mixes_in_class_methods`
#
# @see https://sorbet.org/docs/abstract#interfaces-and-the-included-hook Sorbet `mixes_in_class_methods` documentation
#
# source://yard-sorbet//lib/yard-sorbet/handlers/include_handler.rb#9
class YARDSorbet::Handlers::IncludeHandler < ::YARD::Handlers::Ruby::Base
  # source://yard-sorbet//lib/yard-sorbet/handlers/include_handler.rb#16
  sig { void }
  def process; end

  private

  # source://yard-sorbet//lib/yard-sorbet/handlers/include_handler.rb#28
  sig { returns(::YARD::CodeObjects::NamespaceObject) }
  def included_in; end
end

# Tracks modules that invoke `mixes_in_class_methods` for use in {IncludeHandler}
#
# @see https://sorbet.org/docs/abstract#interfaces-and-the-included-hook Sorbet `mixes_in_class_methods` documentation
#
# source://yard-sorbet//lib/yard-sorbet/handlers/mixes_in_class_methods_handler.rb#9
class YARDSorbet::Handlers::MixesInClassMethodsHandler < ::YARD::Handlers::Ruby::Base
  # source://yard-sorbet//lib/yard-sorbet/handlers/mixes_in_class_methods_handler.rb#23
  sig { void }
  def process; end

  class << self
    # source://yard-sorbet//lib/yard-sorbet/handlers/mixes_in_class_methods_handler.rb#18
    sig { params(code_obj: ::String).returns(T.nilable(T::Array[::String])) }
    def mixed_in_class_methods(code_obj); end
  end
end

# A YARD Handler for Sorbet type declarations
#
# source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#7
class YARDSorbet::Handlers::SigHandler < ::YARD::Handlers::Ruby::Base
  # Swap the method definition docstring and the sig docstring.
  # Parse relevant parts of the `sig` and include them as well.
  #
  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#24
  sig { void }
  def process; end

  private

  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#73
  sig { params(method_objects: T::Array[::YARD::CodeObjects::MethodObject]).void }
  def document_attr_methods(method_objects); end

  # An attr* sig can be merged into a previous attr* docstring if it is the only parameter passed to the attr*
  # declaration. This is to avoid needing to rewrite the source code to separate merged and unmerged attr*
  # declarations.
  #
  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#60
  sig { params(attr_node: ::YARD::Parser::Ruby::MethodCallNode).returns(T::Boolean) }
  def merged_into_attr?(attr_node); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#78
  sig do
    params(
      attach_to: T.any(::YARD::CodeObjects::MethodObject, ::YARD::Parser::Ruby::MethodCallNode, ::YARD::Parser::Ruby::MethodDefinitionNode),
      docstring: T.nilable(::String),
      include_params: T::Boolean
    ).void
  end
  def parse_node(attach_to, docstring, include_params: T.unsafe(nil)); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#99
  sig { params(node: ::YARD::Parser::Ruby::AstNode, docstring: ::YARD::Docstring).void }
  def parse_params(node, docstring); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#109
  sig { params(node: ::YARD::Parser::Ruby::AstNode, docstring: ::YARD::Docstring).void }
  def parse_return(node, docstring); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#87
  sig { params(docstring: ::YARD::Docstring, include_params: T::Boolean).void }
  def parse_sig(docstring, include_params: T.unsafe(nil)); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#50
  sig { params(attr_node: ::YARD::Parser::Ruby::MethodCallNode).void }
  def process_attr(attr_node); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#36
  sig { params(def_node: ::YARD::Parser::Ruby::MethodDefinitionNode).void }
  def process_def(def_node); end
end

# YARD types that can have docstrings attached to them
#
# source://yard-sorbet//lib/yard-sorbet/handlers/sig_handler.rb#14
YARDSorbet::Handlers::SigHandler::Documentable = T.type_alias { T.any(::YARD::CodeObjects::MethodObject, ::YARD::Parser::Ruby::MethodCallNode, ::YARD::Parser::Ruby::MethodDefinitionNode) }

# Class-level handler that folds all `const` and `prop` declarations into the constructor documentation
# this needs to be injected as a module otherwise the default Class handler will overwrite documentation
#
# @note this module is included in `YARD::Handlers::Ruby::ClassHandler`
#
# source://yard-sorbet//lib/yard-sorbet/handlers/struct_class_handler.rb#10
module YARDSorbet::Handlers::StructClassHandler
  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_class_handler.rb#14
  sig { void }
  def process; end

  private

  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_class_handler.rb#50
  sig do
    params(
      object: ::YARD::CodeObjects::MethodObject,
      props: T::Array[::YARDSorbet::TStructProp],
      docstring: ::YARD::Docstring,
      directives: T::Array[::String]
    ).void
  end
  def decorate_t_struct_init(object, props, docstring, directives); end

  # Create a virtual `initialize` method with all the `prop`/`const` arguments
  #
  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_class_handler.rb#30
  sig { params(props: T::Array[::YARDSorbet::TStructProp], class_ns: ::YARD::CodeObjects::ClassObject).void }
  def process_t_struct_props(props, class_ns); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_class_handler.rb#60
  sig { params(props: T::Array[::YARDSorbet::TStructProp]).returns(T::Array[[::String, T.nilable(::String)]]) }
  def to_object_parameters(props); end
end

# Handles all `const`/`prop` calls, creating accessor methods, and compiles them for later usage at the class level
# in creating a constructor
#
# source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#8
class YARDSorbet::Handlers::StructPropHandler < ::YARD::Handlers::Ruby::Base
  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#15
  sig { void }
  def process; end

  private

  # Add the source and docstring to the method object
  #
  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#28
  sig { params(object: ::YARD::CodeObjects::MethodObject, prop: ::YARDSorbet::TStructProp).void }
  def decorate_object(object, prop); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#38
  sig { returns(T::Boolean) }
  def immutable?; end

  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#44
  sig { params(kwd: ::String).returns(T.nilable(::String)) }
  def kw_arg(kwd); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#49
  sig { params(name: ::String).returns(::YARDSorbet::TStructProp) }
  def make_prop(name); end

  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#60
  sig { returns(T::Array[::YARD::Parser::Ruby::AstNode]) }
  def params; end

  # Register the field explicitly as an attribute.
  #
  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#66
  sig { params(object: ::YARD::CodeObjects::MethodObject, name: ::String).void }
  def register_attrs(object, name); end

  # Store the prop for use in the constructor definition
  #
  # source://yard-sorbet//lib/yard-sorbet/handlers/struct_prop_handler.rb#74
  sig { params(prop: ::YARDSorbet::TStructProp).void }
  def update_state(prop); end
end

# Helper methods for working with `YARD` AST Nodes
#
# source://yard-sorbet//lib/yard-sorbet/node_utils.rb#6
module YARDSorbet::NodeUtils
  class << self
    # Traverse AST nodes in breadth-first order
    #
    # @note This will skip over some node types.
    # @yield [YARD::Parser::Ruby::AstNode]
    #
    # source://yard-sorbet//lib/yard-sorbet/node_utils.rb#21
    sig do
      params(
        node: ::YARD::Parser::Ruby::AstNode,
        _blk: T.proc.params(n: ::YARD::Parser::Ruby::AstNode).void
      ).void
    end
    def bfs_traverse(node, &_blk); end

    # source://yard-sorbet//lib/yard-sorbet/node_utils.rb#32
    sig { params(node: ::YARD::Parser::Ruby::AstNode).void }
    def delete_node(node); end

    # Gets the node that a sorbet `sig` can be attached do, bypassing visisbility modifiers and the like
    #
    # source://yard-sorbet//lib/yard-sorbet/node_utils.rb#38
    sig do
      params(
        node: ::YARD::Parser::Ruby::AstNode
      ).returns(T.any(::YARD::Parser::Ruby::MethodCallNode, ::YARD::Parser::Ruby::MethodDefinitionNode))
    end
    def get_method_node(node); end

    # Find and return the adjacent node (ascending)
    #
    # @raise [IndexError] if the node does not have an adjacent sibling (ascending)
    #
    # source://yard-sorbet//lib/yard-sorbet/node_utils.rb#45
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(::YARD::Parser::Ruby::AstNode) }
    def sibling_node(node); end

    # source://yard-sorbet//lib/yard-sorbet/node_utils.rb#52
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Boolean) }
    def sigable_node?(node); end

    # @see https://github.com/lsegal/yard/blob/main/lib/yard/handlers/ruby/attribute_handler.rb YARD::Handlers::Ruby::AttributeHandler.validated_attribute_names
    #
    # source://yard-sorbet//lib/yard-sorbet/node_utils.rb#63
    sig { params(attr_node: ::YARD::Parser::Ruby::MethodCallNode).returns(T::Array[::String]) }
    def validated_attribute_names(attr_node); end
  end
end

# Command node types that can have type signatures
#
# source://yard-sorbet//lib/yard-sorbet/node_utils.rb#10
YARDSorbet::NodeUtils::ATTRIBUTE_METHODS = T.let(T.unsafe(nil), Array)

# Skip these method contents during BFS node traversal, they can have their own nested types via `T.Proc`
#
# source://yard-sorbet//lib/yard-sorbet/node_utils.rb#12
YARDSorbet::NodeUtils::SKIP_METHOD_CONTENTS = T.let(T.unsafe(nil), Array)

# Node types that can have type signatures
#
# source://yard-sorbet//lib/yard-sorbet/node_utils.rb#14
YARDSorbet::NodeUtils::SigableNode = T.type_alias { T.any(::YARD::Parser::Ruby::MethodCallNode, ::YARD::Parser::Ruby::MethodDefinitionNode) }

# Translate `sig` type syntax to `YARD` type syntax.
#
# source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#6
module YARDSorbet::SigToYARD
  class << self
    # @see https://yardoc.org/types.html
    #
    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#23
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert(node); end

    private

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#61
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(::String) }
    def build_generic_type(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#70
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_aref(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#82
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns([::String]) }
    def convert_array(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#90
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns([::String]) }
    def convert_collection(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#97
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns([::String]) }
    def convert_hash(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#105
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_list(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#31
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_node(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#43
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns(T::Array[::String]) }
    def convert_node_type(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#110
    sig { params(node: ::YARD::Parser::Ruby::MethodCallNode).returns(T::Array[::String]) }
    def convert_t_method(node); end

    # source://yard-sorbet//lib/yard-sorbet/sig_to_yard.rb#121
    sig { params(node: ::YARD::Parser::Ruby::AstNode).returns([::String]) }
    def convert_unknown(node); end
  end
end

# Used to store the details of a `T::Struct` `prop` definition
#
# source://yard-sorbet//lib/yard-sorbet/t_struct_prop.rb#6
class YARDSorbet::TStructProp < ::T::Struct
  const :default, T.nilable(::String)
  const :doc, ::String
  const :prop_name, ::String
  const :source, ::String
  const :types, T::Array[::String]

  class << self
    # source://sorbet-runtime/0.5.11237/lib/types/struct.rb#13
    def inherited(s); end
  end
end

# Helper methods for working with `YARD` tags
#
# source://yard-sorbet//lib/yard-sorbet/tag_utils.rb#6
module YARDSorbet::TagUtils
  class << self
    # source://yard-sorbet//lib/yard-sorbet/tag_utils.rb#16
    sig do
      params(
        docstring: ::YARD::Docstring,
        tag_name: ::String,
        name: T.nilable(::String)
      ).returns(T.nilable(::YARD::Tags::Tag))
    end
    def find_tag(docstring, tag_name, name); end

    # Create or update a `YARD` tag with type information
    #
    # source://yard-sorbet//lib/yard-sorbet/tag_utils.rb#30
    sig do
      params(
        docstring: ::YARD::Docstring,
        tag_name: ::String,
        types: T.nilable(T::Array[::String]),
        name: T.nilable(::String),
        text: ::String
      ).void
    end
    def upsert_tag(docstring, tag_name, types = T.unsafe(nil), name = T.unsafe(nil), text = T.unsafe(nil)); end
  end
end

# The `void` return type, as a constant to reduce array allocations
#
# source://yard-sorbet//lib/yard-sorbet/tag_utils.rb#10
YARDSorbet::TagUtils::VOID_RETURN_TYPE = T.let(T.unsafe(nil), Array)

# {https://rubygems.org/gems/yard-sorbet Version history}
#
# source://yard-sorbet//lib/yard-sorbet/version.rb#7
YARDSorbet::VERSION = T.let(T.unsafe(nil), String)
