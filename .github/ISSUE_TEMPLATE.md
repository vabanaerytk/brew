If Homebrew was updated on Aug 10-11th 2016 and `brew update` always says `Already up-to-date.` you need to run: `cd "$(brew --repo)" && git fetch && git reset --hard origin/master && brew update`.

# Please follow the general troubleshooting steps first:

- [ ] Ran `brew update` and retried your prior step?
- [ ] Ran `brew doctor`, fixed as many issues as possible and retried your prior step?
- [ ] Confirmed this is problem with Homebrew/brew and not specific formulae? If it's a formulae-specific problem please file this issue at https://github.com/Homebrew/homebrew-core/issues/new

_You can erase any parts of this template not applicable to your Issue._

### Bug reports:

Please replace this line with a brief summary of your issue **AND** the output of `brew config` and `brew doctor`.

### Propose a feature:

Instead of creating an issue here, please create a pull request with your change proposal in the [Homebrew Evolution](https://github.com/Homebrew/brew-evolution) repository using the [proposal template](https://github.com/Homebrew/brew-evolution/blob/master/proposal_template.md).
