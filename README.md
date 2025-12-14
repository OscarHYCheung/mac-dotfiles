# Oscar's dotfiles

Forked from [Paul Irish's dotfiles](https://github.com/mathiasbynens/dotfiles/) and customised for my own use.

## Prerequisites

1. Xcode Command Line Tools: `xcode-select --install`
2. Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Git (via Homebrew if needed): `brew install git`

## Install

Run the setup script from the repo root:

```bash
bash setup.sh
```

What the script does:

- Ensures Homebrew is present, updates formulae, and installs the packages/casks defined inside (including the latest Homebrew bash).
- If a Brewfile exists, runs `brew bundle --no-lock` to install declared packages/casks; otherwise installs the built-in list.
- Switches the login shell to the Homebrew bash (adding it to `/etc/shells` if needed).
- Installs RVM (with Ruby) and nvm if missing.
- Creates Vim swap/undo/backup directories and symlinks the dotfiles into `$HOME` so they stay in sync with the repo.

## Post-installation

1. Update the username/hostname prompt in `~/.bash_prompt`.
2. Install the recommended apps: [Essential Mac Apps](https://gist.github.com/oscarhycheung/58e313105229a224810a#file-essential_mac_apps-md).
3. Import `config.terminal` into the Terminal app if you want the colour profile.
