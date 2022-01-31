require 'rbconfig'
# ruby 1.8.7 doesn't define RUBY_ENGINE
ruby_engine = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
ruby_version = RbConfig::CONFIG["ruby_version"]
path = File.expand_path('..', __FILE__)
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/concurrent-ruby-1.1.9/lib/concurrent-ruby"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/i18n-1.9.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/minitest-5.15.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/tzinfo-2.0.4/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/zeitwerk-2.5.4/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/activesupport-6.1.4.4/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/public_suffix-4.0.6/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/addressable-2.8.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/ast-2.4.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/bindata-2.4.10/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.6.0-static/msgpack-1.4.4"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/msgpack-1.4.4/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.6.0-static/bootsnap-1.10.2"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/bootsnap-1.10.2/lib"
$:.unshift "#{path}/"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.6.0-static/byebug-11.1.3"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/byebug-11.1.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/coderay-1.1.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/highline-2.0.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/commander-4.6.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/connection_pool-2.2.5/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/did_you_mean-1.6.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/diff-lcs-1.5.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/docile-1.4.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.6.0-static/unf_ext-0.0.8"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/unf_ext-0.0.8/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/unf-0.1.4/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/domain_name-0.5.20190701/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/regexp_parser-2.2.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/ecma-re-validator-0.4.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/elftools-1.1.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/hana-1.3.7/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.6.0-static/hpricot-0.8.6"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/hpricot-0.8.6/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/http-cookie-1.0.4/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/uri_template-0.7.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/json_schemer-0.2.18/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/mime-types-data-3.2022.0105/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/mime-types-3.4.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/net-http-digest_auth-1.4.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/net-http-persistent-4.0.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/mini_portile2-2.7.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.6.0-static/racc-1.6.0"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/racc-1.6.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/nokogiri-1.13.1-x86_64-darwin/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rubyntlm-0.6.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/webrick-1.7.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/webrobots-0.1.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/mechanize-2.8.4/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/method_source-1.0.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/mustache-1.1.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/parallel-1.21.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/parallel_tests-3.7.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/parser-3.1.0.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rainbow-3.1.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/sorbet-runtime-0.5.9589/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/parlour-6.0.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/patchelf-1.3.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/plist-3.6.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/pry-0.14.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rack-2.2.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/unparser-0.6.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rbi-0.0.11/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/extensions/x86_64-darwin-14/2.6.0-static/rdiscount-2.2.0.2"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rdiscount-2.2.0.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rexml-3.2.5/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/ronn-0.7.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-support-3.10.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-core-3.10.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-expectations-3.10.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-mocks-3.10.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-3.10.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-github-2.3.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-its-1.3.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-retry-0.6.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/sorbet-static-0.5.9589-universal-darwin-14/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/sorbet-0.5.9589/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-sorbet-1.8.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec-wait-0.0.9/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rspec_junit_formatter-0.5.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rubocop-ast-1.15.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/ruby-progressbar-1.11.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/unicode-display_width-2.1.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rubocop-1.25.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rubocop-performance-1.13.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rubocop-rails-2.13.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rubocop-rspec-2.8.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/rubocop-sorbet-0.6.5/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/ruby-macho-3.0.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/simplecov-html-0.12.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/simplecov_json_formatter-0.1.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/simplecov-0.21.2/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/simplecov-cobertura-2.1.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/sorbet-runtime-stub-0.2.0/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/thor-1.2.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/spoom-1.1.8/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/yard-0.9.27/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/yard-sorbet-0.6.1/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/tapioca-0.6.3/lib"
$:.unshift "#{path}/../#{ruby_engine}/#{ruby_version}/gems/warning-1.2.1/lib"
