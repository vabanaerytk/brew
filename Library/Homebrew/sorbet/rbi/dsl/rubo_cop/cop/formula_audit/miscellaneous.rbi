# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `RuboCop::Cop::FormulaAudit::Miscellaneous`.
# Please instead update this file by running `bin/tapioca dsl RuboCop::Cop::FormulaAudit::Miscellaneous`.


class RuboCop::Cop::FormulaAudit::Miscellaneous
  sig do
    params(
      node: RuboCop::AST::Node,
      pattern: T.any(String, Symbol),
      kwargs: T.untyped,
      block: T.untyped
    ).returns(T.untyped)
  end
  def conditional_dependencies(node, *pattern, **kwargs, &block); end

  sig { params(node: RuboCop::AST::Node, kwargs: T.untyped, block: T.untyped).returns(T.untyped) }
  def destructure_hash(node, **kwargs, &block); end

  sig do
    params(
      node: RuboCop::AST::Node,
      pattern: T.any(String, Symbol),
      kwargs: T.untyped,
      block: T.untyped
    ).returns(T.untyped)
  end
  def formula_path_strings(node, *pattern, **kwargs, &block); end

  sig { params(node: RuboCop::AST::Node, kwargs: T.untyped, block: T.untyped).returns(T.untyped) }
  def hash_dep(node, **kwargs, &block); end
end
