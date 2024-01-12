# typed: strict
# frozen_string_literal: true

class Hash
  # Validates all keys in a hash match <tt>*valid_keys</tt>, raising
  # +ArgumentError+ on a mismatch.
  #
  # Note that keys are treated differently than HashWithIndifferentAccess,
  # meaning that string and symbol keys will not match.
  #
  #   { name: 'Rob', years: '28' }.assert_valid_keys(:name, :age)
  #   # => raises "ArgumentError: Unknown key: :years. Valid keys are: :name, :age"
  #   { name: 'Rob', age: '28' }.assert_valid_keys('name', 'age')
  #   # => raises "ArgumentError: Unknown key: :name. Valid keys are: 'name', 'age'"
  #   { name: 'Rob', age: '28' }.assert_valid_keys(:name, :age)   # => passes, raises nothing
  sig { params(valid_keys: T.untyped).void }
  def assert_valid_keys(*valid_keys)
    valid_keys.flatten!
    each_key do |k|
      next if valid_keys.include?(k)

      raise ArgumentError,
            "Unknown key: #{T.unsafe(k).inspect}. Valid keys are: #{valid_keys.map(&:inspect).join(", ")}"
    end
  end

  # Returns a new hash with all keys converted by the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes and arrays.
  #
  #  hash = { person: { name: 'Rob', age: '28' } }
  #
  #  hash.deep_transform_keys{ |key| key.to_s.upcase }
  #  # => {"PERSON"=>{"NAME"=>"Rob", "AGE"=>"28"}}
  def deep_transform_keys(&block) = _deep_transform_keys_in_object(self, &block)

  # Destructively converts all keys by using the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes and arrays.
  def deep_transform_keys!(&block) = _deep_transform_keys_in_object!(self, &block)

  # Returns a new hash with all keys converted to strings.
  # This includes the keys from the root hash and from all
  # nested hashes and arrays.
  #
  #   hash = { person: { name: 'Rob', age: '28' } }
  #
  #   hash.deep_stringify_keys
  #   # => {"person"=>{"name"=>"Rob", "age"=>"28"}}
  def deep_stringify_keys = T.unsafe(self).deep_transform_keys(&:to_s)

  # Destructively converts all keys to strings.
  # This includes the keys from the root hash and from all
  # nested hashes and arrays.
  def deep_stringify_keys! = T.unsafe(self).deep_transform_keys!(&:to_s)

  # Returns a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+. This includes the keys from the root hash
  # and from all nested hashes and arrays.
  #
  #   hash = { 'person' => { 'name' => 'Rob', 'age' => '28' } }
  #
  #   hash.deep_symbolize_keys
  #   # => {:person=>{:name=>"Rob", :age=>"28"}}
  def deep_symbolize_keys
    deep_transform_keys do |key|
      T.unsafe(key).to_sym
    rescue
      key
    end
  end

  # Destructively converts all keys to symbols, as long as they respond
  # to +to_sym+. This includes the keys from the root hash and from all
  # nested hashes and arrays.
  def deep_symbolize_keys!
    deep_transform_keys! do |key|
      T.unsafe(key).to_sym
    rescue
      key
    end
  end

  private

  # Support methods for deep transforming nested hashes and arrays.
  sig { params(object: T.anything, block: T.proc.params(k: T.untyped).returns(T.untyped)).returns(T.untyped) }
  def _deep_transform_keys_in_object(object, &block)
    case object
    when Hash
      object.each_with_object({}) do |(key, value), result|
        result[yield(key)] = _deep_transform_keys_in_object(value, &block)
      end
    when Array
      object.map { |e| _deep_transform_keys_in_object(e, &block) }
    else
      object
    end
  end

  sig { params(object: T.anything, block: T.proc.params(k: T.untyped).returns(T.untyped)).returns(T.untyped) }
  def _deep_transform_keys_in_object!(object, &block)
    case object
    when Hash
      object.each_key do |key|
        value = object.delete(key)
        object[yield(key)] = _deep_transform_keys_in_object!(value, &block)
      end
      object
    when Array
      object.map! { |e| _deep_transform_keys_in_object!(e, &block) }
    else
      object
    end
  end
end
