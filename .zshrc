# Enable completions
autoload -Uz compinit;
compinit -C;

# Antibody
. ~/.zsh_antibody_plugins;

# Config
export DISABLE_AUTO_TITLE="true"
export COMPLETION_WAITING_DOTS="true"
export EDITOR="code"
setopt interactivecomments

# After-hook
if [ -f ~/.zshrc_local_after ]; then
  . ~/.zshrc_local_after;
fi
