require "utils/git"

describe Git do
  before(:all) do
    git = HOMEBREW_SHIMS_PATH/"scm/git"
    file = "lib/blah.rb"
    repo = Pathname.new("repo")
    FileUtils.mkpath("repo/lib")
    `#{git} init`
    FileUtils.touch("repo/#{file}")
    File.open(repo.to_s+"/"+file, "w") { |f| f.write("blah") }
    `#{git} add repo/#{file}`
    `#{git} commit -m"File added"`
    @hash1 = `git rev-parse HEAD`
    File.open(repo.to_s+"/"+file, "w") { |f| f.write("brew") }
    `#{git} add repo/#{file}`
    `#{git} commit -m"written to File"`
    @hash2 = `git rev-parse HEAD`
  end

  let(:file) { "lib/blah.rb" }
  let(:repo) { Pathname.new("repo") }

  after(:all) do
    FileUtils.rm_rf("repo")
  end

  describe "#last_revision_commit_of_file" do
    it "sets args as --skip=1 when before_commit is nil" do
      expect(described_class.last_revision_commit_of_file(repo, file)).to eq(@hash1[0..6])
    end

    it "sets args as --skip=1 when before_commit is nil" do
      expect(described_class.last_revision_commit_of_file(repo, file, before_commit: "0..3")).to eq(@hash2[0..6])
    end
  end

  describe "#last_revision_of_file" do
    it "returns last revision of file" do
      expect(described_class.last_revision_of_file(repo, repo.to_s+"/"+file)).to eq("blah")
    end

    it "returns last revision of file based on before_commit" do
      expect(described_class.last_revision_of_file(repo, repo.to_s+"/"+file, before_commit: "0..3")).to eq("brew")
    end
  end
end

describe Utils do
  describe "::git_available?" do
    it "returns true if git --version command succeeds" do
      allow_any_instance_of(Process::Status).to receive(:success?).and_return(true)
      expect(described_class.git_available?).to be_truthy
    end

    it "returns false if git --version command does not succeed" do
      allow_any_instance_of(Process::Status).to receive(:success?).and_return(false)
      expect(described_class.git_available?).to be_falsey
    end

    it "returns git version if already set" do
      described_class.instance_variable_set(:@git, true)
      expect(described_class.git_available?).to be_truthy
      described_class.instance_variable_set(:@git, nil)
    end
  end

  describe "::git_path" do
    context "when git is not available" do
      before do
        described_class.instance_variable_set(:@git, false)
      end

      it "returns" do
        expect(described_class.git_path).to eq(nil)
      end
    end

    context "when git is available" do
      before do
        described_class.instance_variable_set(:@git, true)
      end

      it "returns path of git" do
        expect(described_class.git_path).to eq("/Applications/Xcode.app/Contents/Developer/usr/bin/git")
      end

      it "returns git_path if already set" do
        described_class.instance_variable_set(:@git_path, "git")
        expect(described_class.git_path).to eq("git")
        described_class.instance_variable_set(:@git_path, nil)
      end
    end
  end

  describe "::git_version" do
    context "when git is not available" do
      before do
        described_class.instance_variable_set(:@git, false)
      end

      it "returns" do
        expect(described_class.git_path).to eq(nil)
      end
    end

    context "when git is available" do
      before do
        described_class.instance_variable_set(:@git, true)
      end

      it "returns version of git" do
        expect(described_class.git_version).not_to be_nil
      end

      it "returns git_version if already set" do
        described_class.instance_variable_set(:@git_version, "v1")
        expect(described_class.git_version).to eq("v1")
        described_class.instance_variable_set(:@git_version, nil)
      end
    end
  end

  describe "::git_remote_exists" do
    context "when git is not available" do
      before do
        described_class.instance_variable_set(:@git, false)
      end

      it "returns true" do
        expect(described_class.git_remote_exists("blah")).to be_truthy
      end
    end

    context "when git is available" do
      before(:all) do
        described_class.instance_variable_set(:@git, true)
        git = HOMEBREW_SHIMS_PATH/"scm/git"
        @repo = Pathname.new("hey")
        FileUtils.mkpath("hey")
        `cd #{@repo}`
        `#{git} init`
        `#{git} remote add origin git@github.com:Homebrew/brew`
        `cd ..`
      end

      after(:all) do
        FileUtils.rm_rf(@repo)
      end

      it "returns true when git remote exists" do
        expect(described_class.git_remote_exists("git@github.com:Homebrew/brew")).to be_truthy
      end

      it "returns false when git remote does not exist" do
        expect(described_class.git_remote_exists("blah")).to be_falsey
      end
    end
  end

  describe "::clear_git_available_cache" do
    it "removes @git_path and @git_version if defined" do
      described_class.clear_git_available_cache
      expect(@git_path).to be_nil
      expect(@git_version).to be_nil
    end

    it "removes @git if defined" do
      described_class.instance_variable_set(:@git, true)
      described_class.clear_git_available_cache
      expect(@git).to be_nil
      expect(@git_path).to be_nil
      expect(@git_version).to be_nil
    end
  end
end
