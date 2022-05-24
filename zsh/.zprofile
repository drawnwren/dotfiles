export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

