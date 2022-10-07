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
