# frozen_string_literal: true

require "cmd/shared_examples/args_parse"

RSpec.describe "brew unbottled" do
  it_behaves_like "parseable arguments"
end
