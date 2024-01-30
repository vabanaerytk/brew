# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rspec-sorbet` gem.
# Please instead update this file by running `bin/tapioca gem rspec-sorbet`.

# source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#6
module RSpec
  class << self
    # source://rspec-core/3.12.2/lib/rspec/core.rb#70
    def clear_examples; end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#85
    def configuration; end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#49
    def configuration=(_arg0); end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#97
    def configure; end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#194
    def const_missing(name); end

    # source://rspec-core/3.12.2/lib/rspec/core/dsl.rb#42
    def context(*args, &example_group_block); end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#122
    def current_example; end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#128
    def current_example=(example); end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#154
    def current_scope; end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#134
    def current_scope=(scope); end

    # source://rspec-core/3.12.2/lib/rspec/core/dsl.rb#42
    def describe(*args, &example_group_block); end

    # source://rspec-core/3.12.2/lib/rspec/core/dsl.rb#42
    def example_group(*args, &example_group_block); end

    # source://rspec-core/3.12.2/lib/rspec/core/dsl.rb#42
    def fcontext(*args, &example_group_block); end

    # source://rspec-core/3.12.2/lib/rspec/core/dsl.rb#42
    def fdescribe(*args, &example_group_block); end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#58
    def reset; end

    # source://rspec-core/3.12.2/lib/rspec/core/shared_example_group.rb#110
    def shared_context(name, *args, &block); end

    # source://rspec-core/3.12.2/lib/rspec/core/shared_example_group.rb#110
    def shared_examples(name, *args, &block); end

    # source://rspec-core/3.12.2/lib/rspec/core/shared_example_group.rb#110
    def shared_examples_for(name, *args, &block); end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#160
    def world; end

    # source://rspec-core/3.12.2/lib/rspec/core.rb#49
    def world=(_arg0); end

    # source://rspec-core/3.12.2/lib/rspec/core/dsl.rb#42
    def xcontext(*args, &example_group_block); end

    # source://rspec-core/3.12.2/lib/rspec/core/dsl.rb#42
    def xdescribe(*args, &example_group_block); end
  end
end

# source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#7
module RSpec::Sorbet
  extend ::RSpec::Sorbet::Doubles
end

# source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#8
module RSpec::Sorbet::Doubles
  requires_ancestor { Kernel }

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#15
  sig { void }
  def allow_doubles!; end

  # @return [void]
  #
  # source://sorbet-runtime/0.5.11219/lib/types/private/methods/_methods.rb#252
  def allow_instance_doubles!(*args, **_arg1, &blk); end

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#36
  sig { params(clear_existing: T::Boolean).void }
  def reset!(clear_existing: T.unsafe(nil)); end

  private

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#139
  sig { params(signature: T.untyped, opts: T::Hash[T.untyped, T.untyped]).void }
  def call_validation_error_handler(signature, opts); end

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#65
  sig { returns(T.nilable(T::Boolean)) }
  def configured; end

  # @return [Boolean, nil]
  #
  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#65
  def configured=(_arg0); end

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#127
  sig { params(message: ::String).returns(T::Boolean) }
  def double_message_with_ellipsis?(message); end

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#62
  sig { returns(T.nilable(T.proc.params(signature: T.untyped, opts: T::Hash[T.untyped, T.untyped]).void)) }
  def existing_call_validation_error_handler; end

  # @return [T.proc.params(signature: T.untyped, opts: T::Hash[T.untyped, T.untyped]).void, nil]
  #
  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#62
  def existing_call_validation_error_handler=(_arg0); end

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#59
  sig { returns(T.nilable(T.proc.params(signature: ::Exception).void)) }
  def existing_inline_type_error_handler; end

  # @return [T.proc.params(signature: Exception).void, nil]
  #
  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#59
  def existing_inline_type_error_handler=(_arg0); end

  # @raise [TypeError]
  #
  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#73
  sig { params(signature: T.untyped, opts: T.untyped).void }
  def handle_call_validation_error(signature, opts); end

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#80
  sig { params(error: ::Exception).void }
  def inline_type_error_handler(error); end

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#134
  sig { params(message: ::String).returns(T::Boolean) }
  def typed_array_message?(message); end

  # source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#118
  sig { params(message: ::String).returns(T::Boolean) }
  def unable_to_check_type_for_message?(message); end
end

# source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#68
RSpec::Sorbet::Doubles::INLINE_DOUBLE_REGEX = T.let(T.unsafe(nil), Regexp)

# source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#131
RSpec::Sorbet::Doubles::TYPED_ARRAY_MESSAGE = T.let(T.unsafe(nil), Regexp)

# source://rspec-sorbet//lib/rspec/sorbet/doubles.rb#123
RSpec::Sorbet::Doubles::VERIFYING_DOUBLE_OR_DOUBLE = T.let(T.unsafe(nil), Regexp)
