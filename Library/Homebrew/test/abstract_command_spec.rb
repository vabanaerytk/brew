# frozen_string_literal: true

require "abstract_command"

RSpec.describe Homebrew::AbstractCommand do
  describe "subclasses" do
    before do
      test_cat = Class.new(described_class) do
        cmd_args do
          switch "--foo"
          flag "--bar="
        end
        def run; end
      end
      stub_const("TestCat", test_cat)
    end

    describe "parsing args" do
      it "parses valid args" do
        expect { TestCat.new(["--foo"]).run }.not_to raise_error
      end

      it "allows access to args" do
        expect(TestCat.new(["--bar", "baz"]).args[:bar]).to eq("baz")
      end

      it "raises on invalid args" do
        expect { TestCat.new(["--bat"]) }.to raise_error(OptionParser::InvalidOption)
      end
    end

    describe "command names" do
      it "has a default command name" do
        expect(TestCat.command_name).to eq("test-cat")
      end

      it "can lookup command" do
        expect(described_class.command("test-cat")).to be(TestCat)
      end

      describe "when command name is overridden" do
        before do
          tac = Class.new(described_class) do
            def self.command_name = "t-a-c"
            def run; end
          end
          stub_const("Tac", tac)
        end

        it "can be looked up by command name" do
          expect(described_class.command("t-a-c")).to be(Tac)
        end
      end
    end
  end
end
