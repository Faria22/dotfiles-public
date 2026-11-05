export EDITOR="nvim"

export EZA_CONFIG_DIR="${HOME}/.config/eza"

# Make and move to a temporary directory
tmp () {
  cd "$(mktemp -d)"
  chmod -R 0700 .
  if [[ $# -eq 1 ]]; then
    \mkdir -p "$1"
    cd "$1"
    chmod -R 0700 .
  fi
}

# Make and move to a directory
mkcd () {
  \mkdir -p "$1"
  cd "$1"
}
