require "testing_env"
require "dependency"

class DependableTests < Homebrew::TestCase
  def setup
    @tags = ["foo", "bar", :build]
    @dep = Struct.new(:tags).new(@tags).extend(Dependable)
  end

  def test_options
    assert_equal %w[--foo --bar].sort, @dep.options.as_flags.sort
  end

  def test_interrogation
    assert_predicate @dep, :build?
    refute_predicate @dep, :optional?
    refute_predicate @dep, :recommended?
  end
end

class DependencyTests < Homebrew::TestCase
  def test_accepts_single_tag
    dep = Dependency.new("foo", %w[bar])
    assert_equal %w[bar], dep.tags
  end

  def test_accepts_multiple_tags
    dep = Dependency.new("foo", %w[bar baz])
    assert_equal %w[bar baz].sort, dep.tags.sort
  end

  def test_preserves_symbol_tags
    dep = Dependency.new("foo", [:build])
    assert_equal [:build], dep.tags
  end

  def test_accepts_symbol_and_string_tags
    dep = Dependency.new("foo", [:build, "bar"])
    assert_equal [:build, "bar"], dep.tags
  end

  def test_merge_repeats
    dep = Dependency.new("foo", [:build], nil, "foo")
    dep2 = Dependency.new("foo", ["bar"], nil, "foo2")
    dep3 = Dependency.new("xyz", ["abc"], nil, "foo")
    merged = Dependency.merge_repeats([dep, dep2, dep3])
    assert_equal 2, merged.length
    assert_equal Dependency, merged.first.class

    foo_named_dep = merged.find {|d| d.name == "foo"}
    assert_equal [:build, "bar"], foo_named_dep.tags
    assert_includes foo_named_dep.option_name, "foo"
    assert_includes foo_named_dep.option_name, "foo2"

    xyz_named_dep = merged.find {|d| d.name == "xyz"}
    assert_equal ["abc"], xyz_named_dep.tags
    assert_includes xyz_named_dep.option_name, "foo"
    refute_includes xyz_named_dep.option_name, "foo2"
  end

  def test_equality
    foo1 = Dependency.new("foo")
    foo2 = Dependency.new("foo")
    bar = Dependency.new("bar")
    assert_equal foo1, foo2
    assert_eql foo1, foo2
    refute_equal foo1, bar
    refute_eql foo1, bar
    foo3 = Dependency.new("foo", [:build])
    refute_equal foo1, foo3
    refute_eql foo1, foo3
  end
end

class TapDependencyTests < Homebrew::TestCase
  def test_option_name
    dep = TapDependency.new("foo/bar/dog")
    assert_equal "dog", dep.option_name
  end
end
