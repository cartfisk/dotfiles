#!/bin/bash

# Constants

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

PATH_TO_DOTFILES=$(pwd);
HOSTNAME=$(hostname -f);

ACTIONS=("brew_update" "push_update");
DESCRIPTIONS=(
"Regenerate lists of installed brew packages for this machine? ${DARKGREY}(${HOSTNAME})"
"Push updates to GitHub?"
);

# Actions
update()
{
  if $1 ; then
    brew_update;
    push_update;
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

brew_update()
{
  step-runner "brew leaves" "$PATH_TO_DOTFILES/local/$HOSTNAME/brew/brew-installs.txt";
  step-runner "brew cask list" "$PATH_TO_DOTFILES/local/$HOSTNAME/brew/brew-cask-installs.txt";
}

step-runner()
{
  mkdir "$PATH_TO_DOTFILES/local/$HOSTNAME" || true
  mkdir "$PATH_TO_DOTFILES/local/$HOSTNAME/brew" || true
  echo -e "\n>${LBLUE}\`${1}\`${RESTORE}\n"
  echo "$($1)" | tee "$2";
}

push_update()
{
  git add .;
  git commit -m "config update from $HOSTNAME";
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
    brew_update;
  elif [ "$argument" == "push" ]; then
    push;
  else
    update $noconfirm;
  fi
}

main "$@";
