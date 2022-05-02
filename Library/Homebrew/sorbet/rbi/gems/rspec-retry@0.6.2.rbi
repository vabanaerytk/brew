# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rspec-retry` gem.
# Please instead update this file by running `bin/tapioca gem rspec-retry`.

module RSpec
  extend ::RSpec::Support::Warnings
  extend ::RSpec::Core::Warnings

  class << self
    def clear_examples; end
    def configuration; end
    def configuration=(_arg0); end
    def configure; end
    def const_missing(name); end
    def context(*args, &example_group_block); end
    def current_example; end
    def current_example=(example); end
    def current_scope; end
    def current_scope=(scope); end
    def describe(*args, &example_group_block); end
    def example_group(*args, &example_group_block); end
    def fcontext(*args, &example_group_block); end
    def fdescribe(*args, &example_group_block); end
    def reset; end
    def shared_context(name, *args, &block); end
    def shared_examples(name, *args, &block); end
    def shared_examples_for(name, *args, &block); end
    def world; end
    def world=(_arg0); end
    def xcontext(*args, &example_group_block); end
    def xdescribe(*args, &example_group_block); end
  end
end

module RSpec::Core
  class << self
    def path_to_executable; end
  end
end

class RSpec::Core::DeprecationError < ::StandardError; end

class RSpec::Core::Example
  def initialize(example_group_class, description, user_metadata, example_block = T.unsafe(nil)); end

  def attempts; end
  def attempts=(_arg0); end
  def clear_exception; end
  def clock; end
  def clock=(_arg0); end
  def description; end
  def display_exception; end
  def display_exception=(ex); end
  def duplicate_with(metadata_overrides = T.unsafe(nil)); end
  def example_group; end
  def example_group_instance; end
  def exception; end
  def execution_result; end
  def fail_with_exception(reporter, exception); end
  def file_path; end
  def full_description; end
  def id; end
  def inspect; end
  def inspect_output; end
  def instance_exec(*args, &block); end
  def location; end
  def location_rerun_argument; end
  def metadata; end
  def pending; end
  def pending?; end
  def reporter; end
  def rerun_argument; end
  def run(example_group_instance, reporter); end
  def set_aggregate_failures_exception(exception); end
  def set_exception(exception); end
  def skip; end
  def skip_with_exception(reporter, exception); end
  def skipped?; end
  def to_s; end
  def update_inherited_metadata(updates); end

  private

  def assign_generated_description; end
  def finish(reporter); end
  def generate_description; end
  def hooks; end
  def location_description; end
  def mocks_need_verification?; end
  def record_finished(status, reporter); end
  def run_after_example; end
  def run_before_example; end
  def start(reporter); end
  def verify_mocks; end
  def with_around_and_singleton_context_hooks; end
  def with_around_example_hooks; end

  class << self
    def delegate_to_metadata(key); end
    def parse_id(id); end
  end
end

RSpec::Core::Example::AllExceptionsExcludingDangerousOnesOnRubiesThatAllowIt = RSpec::Support::AllExceptionsExceptOnesWeMustNotRescue

class RSpec::Core::Example::Procsy
  def initialize(example, &block); end

  def <<(*a, &b); end
  def ===(*a, &b); end
  def >>(*a, &b); end
  def [](*a, &b); end
  def arity(*a, &b); end
  def attempts; end
  def binding(*a, &b); end
  def call(*args, &block); end
  def clock(*a, &b); end
  def clock=(*a, &b); end
  def clone(*a, &b); end
  def curry(*a, &b); end
  def description(*a, &b); end
  def dup(*a, &b); end
  def duplicate_with(*a, &b); end
  def example; end
  def example_group(*a, &b); end
  def example_group_instance(*a, &b); end
  def exception(*a, &b); end
  def executed?; end
  def execution_result(*a, &b); end
  def file_path(*a, &b); end
  def full_description(*a, &b); end
  def hash(*a, &b); end
  def id(*a, &b); end
  def inspect; end
  def inspect_output(*a, &b); end
  def lambda?(*a, &b); end
  def location(*a, &b); end
  def location_rerun_argument(*a, &b); end
  def metadata(*a, &b); end
  def parameters(*a, &b); end
  def pending(*a, &b); end
  def pending?(*a, &b); end
  def reporter(*a, &b); end
  def rerun_argument(*a, &b); end
  def run(*args, &block); end
  def run_with_retry(opts = T.unsafe(nil)); end
  def skip(*a, &b); end
  def skipped?(*a, &b); end
  def source_location(*a, &b); end
  def to_proc; end
  def update_inherited_metadata(*a, &b); end
  def wrap(&block); end
  def yield(*a, &b); end
end

class RSpec::Core::ExampleGroup
  include ::RSpec::Core::MemoizedHelpers
  include ::RSpec::Core::Pending
  extend ::RSpec::Core::Hooks
  extend ::RSpec::Core::MemoizedHelpers::ClassMethods
  extend ::RSpec::Core::SharedExampleGroup

  def initialize(inspect_output = T.unsafe(nil)); end

  def clear_lets; end
  def clear_memoized; end
  def described_class; end
  def inspect; end

  private

  def method_missing(name, *args); end

  class << self
    def add_example(example); end
    def before_context_ivars; end
    def children; end
    def context(*args, &example_group_block); end
    def currently_executing_a_context_hook?; end
    def declaration_locations; end
    def define_example_group_method(name, metadata = T.unsafe(nil)); end
    def define_example_method(name, extra_options = T.unsafe(nil)); end
    def define_nested_shared_group_method(new_name, report_label = T.unsafe(nil)); end
    def delegate_to_metadata(*names); end
    def descendant_filtered_examples; end
    def descendants; end
    def describe(*args, &example_group_block); end
    def described_class; end
    def description; end
    def each_instance_variable_for_example(group); end
    def ensure_example_groups_are_configured; end
    def example(*all_args, &block); end
    def example_group(*args, &example_group_block); end
    def examples; end
    def fcontext(*args, &example_group_block); end
    def fdescribe(*args, &example_group_block); end
    def fexample(*all_args, &block); end
    def file_path; end
    def filtered_examples; end
    def find_and_eval_shared(label, name, inclusion_location, *args, &customization_block); end
    def fit(*all_args, &block); end
    def focus(*all_args, &block); end
    def for_filtered_examples(reporter, &block); end
    def fspecify(*all_args, &block); end
    def id; end
    def idempotently_define_singleton_method(name, &definition); end
    def include_context(name, *args, &block); end
    def include_examples(name, *args, &block); end
    def it(*all_args, &block); end
    def it_behaves_like(name, *args, &customization_block); end
    def it_should_behave_like(name, *args, &customization_block); end
    def location; end
    def metadata; end
    def next_runnable_index_for(file); end
    def ordering_strategy; end
    def parent_groups; end
    def pending(*all_args, &block); end
    def remove_example(example); end
    def reset_memoized; end
    def run(reporter = T.unsafe(nil)); end
    def run_after_context_hooks(example_group_instance); end
    def run_before_context_hooks(example_group_instance); end
    def run_examples(reporter); end
    def set_it_up(description, args, registration_collection, &example_group_block); end
    def set_ivars(instance, ivars); end
    def skip(*all_args, &block); end
    def specify(*all_args, &block); end
    def store_before_context_ivars(example_group_instance); end
    def subclass(parent, description, args, registration_collection, &example_group_block); end
    def superclass_before_context_ivars; end
    def superclass_metadata; end
    def top_level?; end
    def top_level_description; end
    def traverse_tree_until(&block); end
    def update_inherited_metadata(updates); end
    def with_replaced_metadata(meta); end
    def xcontext(*args, &example_group_block); end
    def xdescribe(*args, &example_group_block); end
    def xexample(*all_args, &block); end
    def xit(*all_args, &block); end
    def xspecify(*all_args, &block); end

    private

    def method_missing(name, *args); end
  end
end

RSpec::Core::ExampleGroup::INSTANCE_VARIABLE_TO_IGNORE = T.let(T.unsafe(nil), Symbol)
class RSpec::Core::ExampleGroup::WrongScopeError < ::NoMethodError; end
RSpec::Core::ExclusionRules = RSpec::Core::FilterRules
RSpec::MODULES_TO_AUTOLOAD = T.let(T.unsafe(nil), Hash)

class RSpec::Retry
  def initialize(ex, opts = T.unsafe(nil)); end

  def attempts; end
  def attempts=(val); end
  def clear_lets; end
  def context; end
  def current_example; end
  def display_try_failure_messages?; end
  def ex; end
  def exceptions_to_hard_fail; end
  def exceptions_to_retry; end
  def retry_count; end
  def run; end
  def sleep_interval; end
  def verbose_retry?; end

  private

  def exception_exists_in?(list, exception); end
  def ordinalize(number); end

  class << self
    def setup; end
  end
end

RSpec::Retry::VERSION = T.let(T.unsafe(nil), String)
RSpec::SharedContext = RSpec::Core::SharedContext
