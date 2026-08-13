# Start
sudo echo Starting...
mydir=$(pwd)
# Basic bash aliases
cp .bash_aliases ~/.bash_aliases
# Install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
sudo apt install tree-sitter-cli
ln -s $mydir/nvim/ ~/.config/nvim
# Install tmux
sudo apt install tmux
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Git difftool: use neovim, allow editing during diff
git config --global diff.tool nvimdiff
git config --global difftool.prompt false


