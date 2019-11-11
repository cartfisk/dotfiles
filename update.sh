#!/bin/bash

# Constants
PATH_TO_DOTFILES=$(pwd);
HOSTNAME=$(hostname -f);

ACTIONS=("brew" "push");
DESCRIPTIONS=(
"Regenerate lists of installed brew packages for this machine? ${DARKGREY}($HOSTNAME)"
"Push updates to GitHub?"
);

# Colors
RESTORE=$(echo -en '\033[00m')
RED=$(echo -en '\033[00;31m')
GREEN=$(echo -en '\033[00;32m')
YELLOW=$(echo -en '\033[00;33m')
BLUE=$(echo -en '\033[00;34m')
MAGENTA=$(echo -en '\033[00;35m')
PURPLE=$(echo -en '\033[00;35m')
CYAN=$(echo -en '\033[00;36m')
LIGHTGRAY=$(echo -en '\033[00;37m')
DARKGRAY=$(echo -en '\033[00;90m')
LRED=$(echo -en '\033[01;31m')
LGREEN=$(echo -en '\033[00;32m')
LYELLOW=$(echo -en '\033[01;33m')
LBLUE=$(echo -en '\033[01;34m')
LMAGENTA=$(echo -en '\033[01;35m')
LPURPLE=$(echo -en '\033[01;35m')
LCYAN=$(echo -en '\033[01;36m')
WHITE=$(echo -en '\033[01;37m')

# Actions
update()
{
  if $1 ; then
    brew;
    zsh;
    push;
  else
    step_index=0
    echo -e "*** ${YELLOW}UPDATE DOTFILES${RESTORE} ***"
    for step in "${ACTIONS[@]}"; do
      echo -e "${GREEN}${DESCRIPTIONS[step_index]}${RESTORE}"
      select yn in "Yes" "No"; do
        case $yn in
          Yes ) $step; break;;
          No ) break;;
        esac
      done
      step_index=$((step_index + 1));
      printf "\n";
    done
  fi
  exit 0;
}

brew()
{
  brew-list;
  brew-cask-list;
}

brew-list()
{
  brew list | tee "$PATH_TO_DOTFILES/local/$HOSTNAME/brew/brew-list.txt";
}

brew-cask-list()
{
  brew cask list | tee "$PATH_TO_DOTFILES/local/$HOSTNAME/brew/brew-cask-list.txt";
}

push()
{
  git add .;
  git commit;
  git push origin master --force;
}

# Entry
set -e

main()
{
  noconfirm=false
  argument=$1

  while getopts ':f' option; do
    case "$option" in
      f) noconfirm=true
        argument="$2"
        ;;
    \?) printf "illegal option: -%s\n\n" "$OPTARG" >&2
        echo "$usage" >&2
        exit 1
        ;;
    esac
  done

  if [ "$argument" == "brew" ]; then
    brew;
  elif [ "$argument" == "push" ]; then
    push;
  else
    update $noconfirm;
  fi
}

main "$@";
