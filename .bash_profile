# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{paths,exports,functions,extra,bash_prompt,aliases}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Exec Z script
. $(brew --prefix z)/etc/profile.d/z.sh

# Exec bash completion
. $(brew --prefix bash-completion)/etc/bash_completion

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load NVM
[[ -s $NVM_DIR/nvm.sh ]] && . $NVM_DIR/nvm.sh
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

source ~/.profile
