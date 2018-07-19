# https://rvm.io
# rvm for the rubiess
curl -L https://get.rvm.io | bash -s stable --ruby

# Install common things
brew tap caskroom/cask
brew install z bash-completion git coreutils vim

# Crearte vim directories
mkdir ~/.vim
mkdir ~/.vim/backups
mkdir ~/.vim/swaps
mkdir ~/.vim/undo

# Copy config files and profiles
cp ./.aliases ./.bash_profile ./.bash_prompt ./.exports ./.functions ./.paths ./.vimrc ./.gitconfig ./.gitignore ~/
