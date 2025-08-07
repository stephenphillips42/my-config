# Start
sudo echo Starting...
mydir=$(pwd)
# Basic bash aliases
cp .bash_aliases ~/.bash_aliases
# Install neovim
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim
# Install tmux
sudo apt install tmux
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


