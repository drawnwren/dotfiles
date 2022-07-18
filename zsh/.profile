export PATH=$PATH:$HOME/.emacs.d/bin/
export GUILE_TLS_CERTIFICATE_DIRECTORY=/usr/local/etc/gnutls/
. "$HOME/.cargo/env"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export PATH="$HOME/.poetry/bin:$PATH"
