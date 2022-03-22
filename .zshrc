
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####

autoload -Uz compinit
compinit

source ~/.zgenom/sources/init.zsh;

alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}";

# Config
setopt interactivecomments;
export CLICOLOR=1;

# History search
bindkey '^[[B' history-substring-search-down;
bindkey '^[[A' history-substring-search-up;
HISTORY_SUBSTRING_SEARCH_PREFIXED="1";

# Ctrl+r config for fzf
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND="rg --files";
  export FZF_DEFAULT_OPTS="-m";
fi

# Run the previous command as sudo, thanks gh:cdfuller!
alias pls='sudo $(fc -nl -1)';

turbo () {
  zcompile ~/.zcompdump;
  zcompile ~/.zshrc;
  [ -f ~/.fzf.zsh ] && zcompile ~/.fzf.zsh;
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh;

# After-hook
if [ -f ~/.zshrc_local_after ]; then
  source ~/.zshrc_local_after;
fi;
