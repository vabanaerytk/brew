# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `RuboCop::Cop::FormulaAuditStrict::Text`.
# Please instead update this file by running `bin/tapioca dsl RuboCop::Cop::FormulaAuditStrict::Text`.

class RuboCop::Cop::FormulaAuditStrict::Text
  sig do
    params(
      node: RuboCop::AST::Node,
      pattern: T.any(String, Symbol),
      kwargs: T.untyped,
      block: T.untyped
    ).returns(T.untyped)
  end
  def interpolated_share_path_starts_with(node, *pattern, **kwargs, &block); end

  sig do
    params(
      node: RuboCop::AST::Node,
      pattern: T.any(String, Symbol),
      kwargs: T.untyped,
      block: T.untyped
    ).returns(T.untyped)
  end
  def share_path_starts_with(node, *pattern, **kwargs, &block); end
end
