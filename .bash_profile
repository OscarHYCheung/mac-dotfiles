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

# Load NVM
[[ -s $NVM_DIR/nvm.sh ]] && . $NVM_DIR/nvm.sh
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

# NVM auto-use logic
if command -v nvm >/dev/null 2>&1; then
    nvm_auto_use() {
        local nvmrc
        nvmrc=$(nvm_find_nvmrc)
        if [[ -n "$nvmrc" ]]; then
            local requested
            requested=$(<"$nvmrc")
            if [[ "$requested" != "$(nvm current)" ]]; then
                nvm use "$requested" --silent >/dev/null 2>&1 || nvm install "$requested"
            fi
        elif [[ "$(nvm current)" != "none" ]]; then
            nvm use default >/dev/null 2>&1
        fi
    }

    # Run the auto-use logic on terminal startup
    nvm_auto_use

    # Wrap cd to trigger auto-use on directory change
    cd() {
        builtin cd "$@" || return $?
        nvm_auto_use
    }
fi

[ -r ~/.profile ] && source ~/.profile
