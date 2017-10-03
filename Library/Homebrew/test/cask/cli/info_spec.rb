describe Hbc::CLI::Info, :cask do
  it "displays some nice info about the specified Cask" do
    expect {
      Hbc::CLI::Info.run("local-caffeine")
    }.to output(<<-EOS.undent).to_stdout
      local-caffeine: 1.2.3
      http://example.com/local-caffeine
      Not installed
      From: https://github.com/caskroom/homebrew-spec/blob/master/Casks/local-caffeine.rb
      ==> Name
      None
      ==> Artifacts
      Caffeine.app (App)
    EOS
  end

  describe "given multiple Casks" do
    let(:expected_output) {
      <<-EOS.undent
        local-caffeine: 1.2.3
        http://example.com/local-caffeine
        Not installed
        From: https://github.com/caskroom/homebrew-spec/blob/master/Casks/local-caffeine.rb
        ==> Name
        None
        ==> Artifacts
        Caffeine.app (App)
        local-transmission: 2.61
        http://example.com/local-transmission
        Not installed
        From: https://github.com/caskroom/homebrew-spec/blob/master/Casks/local-transmission.rb
        ==> Name
        None
        ==> Artifacts
        Transmission.app (App)
      EOS
    }

    it "displays the info" do
      expect {
        Hbc::CLI::Info.run("local-caffeine", "local-transmission")
      }.to output(expected_output).to_stdout
    end

    it "throws away stray options" do
      expect {
        Hbc::CLI::Info.run("--notavalidoption", "local-caffeine", "local-transmission")
      }.to raise_error(/invalid option/)
    end
  end

  it "should print caveats if the Cask provided one" do
    expect {
      Hbc::CLI::Info.run("with-caveats")
    }.to output(<<-EOS.undent).to_stdout
      with-caveats: 1.2.3
      http://example.com/local-caffeine
      Not installed
      From: https://github.com/caskroom/homebrew-spec/blob/master/Casks/with-caveats.rb
      ==> Name
      None
      ==> Artifacts
      Caffeine.app (App)
      ==> Caveats
      Here are some things you might want to know.

      Cask token: with-caveats

      Custom text via puts followed by DSL-generated text:
      To use with-caveats, you may need to add the /custom/path/bin directory
      to your PATH environment variable, eg (for bash shell):

        export PATH=/custom/path/bin:"$PATH"

    EOS
  end

  it 'should not print "Caveats" section divider if the caveats block has no output' do
    expect {
      Hbc::CLI::Info.run("with-conditional-caveats")
    }.to output(<<-EOS.undent).to_stdout
      with-conditional-caveats: 1.2.3
      http://example.com/local-caffeine
      Not installed
      From: https://github.com/caskroom/homebrew-spec/blob/master/Casks/with-conditional-caveats.rb
      ==> Name
      None
      ==> Artifacts
      Caffeine.app (App)
    EOS
  end

  it "prints languages specified in the Cask" do
    expect {
      Hbc::CLI::Info.run("with-languages")
    }.to output(<<-EOS.undent).to_stdout
      with-languages: 1.2.3
      http://example.com/local-caffeine
      Not installed
      From: https://github.com/caskroom/homebrew-spec/blob/master/Casks/with-languages.rb
      ==> Name
      None
      ==> Languages
      zh, en-US
      ==> Artifacts
      Caffeine.app (App)
    EOS
  end

  it 'does not print "Languages" section divider if the languages block has no output' do
    expect {
      Hbc::CLI::Info.run("without-languages")
    }.to output(<<-EOS.undent).to_stdout
      without-languages: 1.2.3
      http://example.com/local-caffeine
      Not installed
      From: https://github.com/caskroom/homebrew-spec/blob/master/Casks/without-languages.rb
      ==> Name
      None
      ==> Artifacts
      Caffeine.app (App)
    EOS
  end

  describe "when no Cask is specified" do
    it "raises an exception" do
      expect {
        Hbc::CLI::Info.run
      }.to raise_error(Hbc::CaskUnspecifiedError)
    end
  end

  describe "when no Cask is specified, but an invalid option" do
    it "raises an exception" do
      expect {
        Hbc::CLI::Info.run("--notavalidoption")
      }.to raise_error(/invalid option/)
    end
  end
end
