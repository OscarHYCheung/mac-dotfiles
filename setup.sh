#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BREW_FORMULAE=(bash z bash-completion@2 git coreutils vim)
BREW_CASKS=(notunes)
DOTFILES=(
	.aliases
	.bash_profile
	.bash_prompt
	.exports
	.functions
	.paths
	.vimrc
	.gitconfig
	.gitignore
)

log() { printf "==> %s\n" "$*"; }

ensure_brew_shellenv() {
	local brew_bin
	brew_bin=$(command -v brew 2>/dev/null || true)
	if [[ -z "$brew_bin" ]]; then
		for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
			if [[ -x "$candidate" ]]; then
				brew_bin="$candidate"
				break
			fi
		done
	fi

	if [[ -n "$brew_bin" ]]; then
		eval "$("$brew_bin" shellenv)"
	fi
}

ensure_homebrew() {
	if command -v brew >/dev/null 2>&1; then
		log "Homebrew already installed"
	else
		log "Installing Homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	ensure_brew_shellenv
}

homebrew_bash_path() {
	local brew_prefix
	brew_prefix=$(brew --prefix 2>/dev/null || true)
	[[ -n "$brew_prefix" ]] && printf "%s/bin/bash" "$brew_prefix"
}

ensure_shell() {
	local target_shell
	target_shell=$(homebrew_bash_path)

	if [[ -z "$target_shell" || ! -x "$target_shell" ]]; then
		log "Homebrew bash not found; skipping shell change"
		return
	fi

	if ! grep -qx "$target_shell" /etc/shells 2>/dev/null; then
		log "Adding $target_shell to /etc/shells (requires sudo)"
		echo "$target_shell" | sudo tee -a /etc/shells >/dev/null
	else
		log "$target_shell already in /etc/shells"
	fi

	local current_shell
	current_shell=$(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')

	if [[ "$current_shell" != "$target_shell" ]]; then
		log "Changing login shell to $target_shell"
		chsh -s "$target_shell"
	else
		log "Login shell already $target_shell"
	fi
}

install_rvm() {
	if [[ -d "$HOME/.rvm" ]]; then
		log "RVM already installed"
	else
		log "Installing RVM (Ruby)"
		curl -fsSL https://get.rvm.io | bash -s stable --ruby
	fi
}

install_nvm() {
	local nvm_version="v0.39.7"
	if [[ -d "$HOME/.nvm" ]]; then
		log "nvm already installed"
	else
		log "Installing nvm ($nvm_version)"
		curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh" | bash
	fi
}

install_brew_packages() {
	log "Ensuring Homebrew packages"
	brew update

	local brewfile_path
	brewfile_path="$SCRIPT_DIR/Brewfile"
	if [[ -f "$brewfile_path" ]]; then
		log "Using Brewfile at $brewfile_path"
		brew bundle install
		return
	fi

	for formula in "${BREW_FORMULAE[@]}"; do
		if brew list --formula "$formula" >/dev/null 2>&1; then
			log "Formula $formula already installed"
		else
			brew install "$formula"
		fi
	done

	for cask in "${BREW_CASKS[@]}"; do
		if brew list --cask "$cask" >/dev/null 2>&1; then
			log "Cask $cask already installed"
		else
			brew install --cask "$cask"
		fi
	done
}

prepare_vim_dirs() {
	log "Creating vim support directories"
	mkdir -p "$HOME/.vim/backups" "$HOME/.vim/swaps" "$HOME/.vim/undo"
}

copy_dotfiles() {
	log "Copying dotfiles to home directory"
	for file in "${DOTFILES[@]}"; do
		local source_path="$SCRIPT_DIR/$file"
		if [[ -f "$source_path" ]]; then
			ln -sf "$source_path" "$HOME/$file"
		else
			log "Skipping missing $file"
		fi
	done
}

main() {
	ensure_homebrew
	ensure_brew_shellenv
	install_brew_packages
	ensure_shell
	install_rvm
	install_nvm
	prepare_vim_dirs
	copy_dotfiles
	log "Setup complete, please restart your terminal session."
}

main "$@"
