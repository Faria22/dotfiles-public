# vim keybinds
bindkey -v

# Ignore pager overrides inherited from Ghostty's launcher.
if [[ $TERM_PROGRAM == ghostty ]]; then
   unset GIT_PAGER PAGER
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Prefer Cargo-managed tools over Homebrew copies.
path=("$HOME/.cargo/bin" $path)
eval "$(starship init zsh)"
eval "$(gdircolors -b)"
eval "$(fzf --zsh)"

# fzf editor keybinds
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }--bind 'ctrl-n:execute(\$EDITOR {})+abort'"

# fzf colors
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
   --color=fg:#D4BE98,bg:-1,hl:#EA6962
   --color=fg+:#D4BE98,bg+:#665C54,hl+:#EA6962
   --color=info:#89B482,prompt:#EA6962,pointer:#EA6962
   --color=marker:#D8A657,spinner:#EA6962,header:#7DAEA3
   --color=list-bg:-1,preview-bg:-1,input-bg:-1'

fzf-file-edit-widget() {
   local file
   setopt localoptions pipefail no_aliases 2> /dev/null
   file=$(
      FZF_DEFAULT_COMMAND=${FZF_CTRL_T_COMMAND:-} \
      FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=file,dir,follow,hidden --scheme=path" "${FZF_CTRL_T_OPTS-}") \
      FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) < /dev/tty
   )
   if [[ -n "$file" ]]; then
      "$EDITOR" "$file"
   fi
   zle reset-prompt
}

zle -N fzf-file-edit-widget
bindkey '^N' fzf-file-edit-widget

# Open the previous command's arguments in the editor.
ee() {
   local -a words
   words=(${(Q)${(z)"$(fc -ln -1)"}})
   "$EDITOR" "${words[@]:1}"
}

eval "$(zoxide init --cmd cd zsh)"
eval "$(aliasmgr init zsh)"

# Shared settings
source ~/.shared_settings.sh

export WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

autoload -Uz colors && colors

# scripts
PATH=$PATH:$HOME/git/dotfiles/scripts

# POV-Ray
PATH=$PATH:"$HOME/povray"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Completions for container
fpath=(~/.zsh/completion $fpath)

# Load completions
autoload -Uz compinit && compinit

ZSH_HIGHLIGHT_STYLES[path]='none'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Correct spelling mistakes in commands
setopt correct

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons=auto --color=always $realpath'

zinit cdreplay -q

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

eval "$(aocctl shell-init)"
