# My aliases
## Basic
alias vim='nvim'
alias vi='nvim'
alias ta='tmux a -t'
alias tn='tmux new -s'
alias tl='tmux ls'
alias py='python3'
alias gop='xdg-open'
alias pygrep='egrep -nHri --include=*py'
alias cppgrep='grep -nHri --include=*cpp --include=*h'
## Python venv Functions
mkenv () {
    # 1. Check if a specific argument was provided
    if [ -n "$1" ]; then
        if [ -d "$1" ]; then
            echo "Directory $1 already exists"
        else
            echo "Making Python virutal environment at $1"
            python -m venv $1
        fi
    # 2. If no argument, check for default names
    elif [ -d ".venv" ]; then
        echo "Directory .venv already exists"
    else
        python -m venv ".venv"
    fi
}
sv() {
    # 1. Check if a specific argument was provided
    if [ -n "$1" ]; then
        if [ -d "$1" ]; then
            source "$1/bin/activate"
        else
            echo "Error: Directory '$1' does not exist."
            return 1
        fi
    # 2. If no argument, check for default names
    elif [ -d ".venv" ]; then
        source .venv/bin/activate
    elif [ -d "venv" ]; then
        source venv/bin/activate
    else
        echo "Error: No argument provided and no '.venv' or 'venv' directory found."
        return 1
    fi
}
complete -d sv
## Basic Path
export PATH="$PATH:/home/sphillips/.local/bin"

## G-Cloud -- for work
alias gcvm_old='gcloud compute ssh --zone "us-central1-c" "sphillips-central-c-ubuntu2204-l4x1-500" --tunnel-through-iap --project "proj-dmm"'
alias gcvm='gcloud compute ssh --zone "us-central1-a" "sphillips-ubuntu2204-l4x1-500-v2" --tunnel-through-iap --project "proj-dmm"'
alias myauth='gcloud auth login --update-adc'
alias mysshauth='gcloud auth login --no-browser --update-adc'
alias mypass='pass show docker-credential-helpers/Z2hjci5pbw\=\=/USERNAME && echo && cat ~/.config/gh/token.txt | gh auth login --with-token'
alias myaptdocker="pass show docker-credential-helpers/Z2hjci5pbw\=\=/USERNAME >/dev/null && cat $HOME/.config/gh/token.txt | gh auth login --with-token && docker pull ghcr.io/bdaiinstitute/dmm_amd64:main && ./docker/start.sh -d -x -b -e sphillips-dev"
alias myshell="./docker/shell.sh -d -x -b -e sphillips-dev"
ETHIP=$(ip -4 addr show  | grep -A 1 "[0-9]*: e.*:" | grep -o "inet [0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*" | grep -o "[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*")
## Brew
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
