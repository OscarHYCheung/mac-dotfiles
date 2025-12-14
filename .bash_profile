# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{paths,exports,functions,extra,bash_prompt,aliases}; do
	[ -r "$file" ] && source "$file"
done
unset file

if command -v brew >/dev/null 2>&1; then
	# Exec Z script
	if [[ -r "$(brew --prefix z)/etc/profile.d/z.sh" ]]; then
		. "$(brew --prefix z)/etc/profile.d/z.sh"
	fi

	# Exec bash completion (prefer bash-completion@2 for Bash 4+)
	if [[ -f "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
		. "$(brew --prefix)/etc/profile.d/bash_completion.sh"
	elif [[ -f "$(brew --prefix bash-completion)/etc/bash_completion" ]]; then
		. "$(brew --prefix bash-completion)/etc/bash_completion"
	fi
fi

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load NVM
[[ -s $NVM_DIR/nvm.sh ]] && . $NVM_DIR/nvm.sh
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

# Auto-use Node version from .nvmrc on directory change by wrapping cd
if command -v nvm >/dev/null 2>&1 && typeset -f nvm_find_nvmrc >/dev/null 2>&1; then
	nvm_auto_use_cd() {
		local nvmrc
		nvmrc=$(nvm_find_nvmrc)
		if [[ -n "$nvmrc" ]]; then
			local requested
			requested=$(<"$nvmrc")
			if [[ "$requested" != "${NVM_AUTO_USE_CURRENT:-}" ]]; then
				nvm use --silent >/dev/null 2>&1 && NVM_AUTO_USE_CURRENT="$requested"
			fi
		elif [[ -n "${NVM_AUTO_USE_CURRENT:-}" ]]; then
			nvm use default >/dev/null 2>&1
			unset NVM_AUTO_USE_CURRENT
		fi
	}

	cd() {
		nvm_auto_use_cd
		builtin cd "$@" || return $?
	}
fi

source ~/.profile
