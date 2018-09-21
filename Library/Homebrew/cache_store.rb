require "dbm"
require "json"
require "timeout"

#
# `CacheStoreDatabase` acts as an interface to a persistent storage mechanism
# residing in the `HOMEBREW_CACHE`
#
class CacheStoreDatabase
  # Yields the cache store database.
  # Closes the database after use if it has been loaded.
  #
  # @param  [Symbol] type
  # @yield  [CacheStoreDatabase] self
  def self.use(type)
    database = CacheStoreDatabase.new(type)
    return_value = yield(database)
    database.close_if_open!
    return_value
  end

  # Sets a value in the underlying database (and creates it if necessary).
  def set(key, value)
    db[key] = value
  end

  # Gets a value from the underlying database (if it already exists).
  def get(key)
    return unless created?

    db[key]
  end

  # Gets a value from the underlying database (if it already exists).
  def delete(key)
    return unless created?

    db.delete(key)
  end

  # Closes the underlying database (if it created and open).
  def close_if_open!
    @db&.close
  end

  # Returns `true` if the cache file has been created for the given `@type`
  #
  # @return [Boolean]
  def created?
    cache_path.exist?
  end

  private

  # The mode of any created files will be 0664 (that is, readable and writable
  # by the owner and the group, and readable by everyone else). Files created
  # will also be modified by the process' umask value at the time of creation:
  #   https://docs.oracle.com/cd/E17276_01/html/api_reference/C/envopen.html
  DATABASE_MODE = 0664

  # Spend 5 seconds trying to read the DBM file. If it takes longer than this it
  # has likely hung or segfaulted.
  DBM_TEST_READ_TIMEOUT = 5

  # Lazily loaded database in read/write mode. If this method is called, a
  # database file with be created in the `HOMEBREW_CACHE` with name
  # corresponding to the `@type` instance variable
  #
  # @return [DBM] db
  def db
    # DBM::WRCREAT: Creates the database if it does not already exist
    @db ||= begin
      HOMEBREW_CACHE.mkpath
      if created?
        dbm_test_read_cmd = SystemCommand.new(
          ENV["HOMEBREW_RUBY_PATH"],
          args: [
            "-rdbm",
            "-e",
            "DBM.open('#{dbm_file_path}', #{DATABASE_MODE}, DBM::READER).size",
          ],
          print_stderr: false,
          must_succeed: true,
        )
        dbm_test_read_success = begin
          Timeout.timeout(DBM_TEST_READ_TIMEOUT) do
            dbm_test_read_cmd.run!
            true
          end
        rescue ErrorDuringExecution, Timeout::Error
          odebug "Failed to read #{dbm_file_path}!"
          begin
            Process.kill(:KILL, dbm_test_read_cmd.pid)
          rescue Errno::ESRCH
            # Process has already terminated.
            nil
          end
          false
        end
        Utils::Analytics.report_event("dbm_test_read", dbm_test_read_success.to_s)
        cache_path.delete unless dbm_test_read_success
      end
      DBM.open(dbm_file_path, DATABASE_MODE, DBM::WRCREAT)
    end
  end

  # Creates a CacheStoreDatabase
  #
  # @param  [Symbol] type
  # @return [nil]
  def initialize(type)
    @type = type
  end

  # `DBM` appends `.db` file extension to the path provided, which is why it's
  # not included
  #
  # @return [String]
  def dbm_file_path
    "#{HOMEBREW_CACHE}/#{@type}"
  end

  # The path where the database resides in the `HOMEBREW_CACHE` for the given
  # `@type`
  #
  # @return [String]
  def cache_path
    Pathname("#{dbm_file_path}.db")
  end
end

#
# `CacheStore` provides methods to mutate and fetch data from a persistent
# storage mechanism
#
class CacheStore
  # @param  [CacheStoreDatabase] database
  # @return [nil]
  def initialize(database)
    @database = database
  end

  # Inserts new values or updates existing cached values to persistent storage
  # mechanism
  #
  # @abstract
  def update!(*)
    raise NotImplementedError
  end

  # Fetches cached values in persistent storage according to the type of data
  # stored
  #
  # @abstract
  def fetch_type(*)
    raise NotImplementedError
  end

  # Deletes data from the cache based on a condition defined in a concrete class
  #
  # @abstract
  def flush_cache!
    raise NotImplementedError
  end

  protected

  # @return [CacheStoreDatabase]
  attr_reader :database

  # DBM stores ruby objects as a ruby `String`. Hence, when fetching the data,
  # to convert the ruby string back into a ruby `Hash`, the string is converted
  # into a JSON compatible string in `ruby_hash_to_json_string`, where it may
  # later be parsed by `JSON.parse` in the `json_string_to_ruby_hash` method
  #
  # @param  [Hash] ruby `Hash` to be converted to `JSON` string
  # @return [String]
  def ruby_hash_to_json_string(hash)
    hash.to_json
  end

  # @param  [String] `JSON` string to be converted to ruby `Hash`
  # @return [Hash]
  def json_string_to_ruby_hash(string)
    JSON.parse(string)
  end
end
