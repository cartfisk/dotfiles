#!/bin/bash

# Constants
PATH_TO_DOTFILES=$(pwd);
TARGET_DIR="$HOME";
HOSTNAME=$(hostname -f)
SYMLINK_SOURCE_FNAMES=(
".zshrc"
"local/$HOSTNAME/.zshrc_local_after"
"local/$HOSTNAME/.gitconfig"
);
SYMLINK_TARGET_FNAMES=(
"$TARGET_DIR/.zshrc"
"$TARGET_DIR/.zshrc_local_after"
"$TARGET_DIR/.gitconfig"
);
ANTIBODY_PLUGIN_LIST_PATH="$PATH_TO_DOTFILES/.zsh_antibody_plugins.txt";
TARGET_ANTIBODY_PATH="$TARGET_DIR/.zsh_antibody_plugins";

BREW_INSTALLS=$(<$PATH_TO_DOTFILES/brew/brew-installs.txt | tr '\n' ' ')
BREW_CASK_INSTALLS=$(<$PATH_TO_DOTFILES/brew/brew-cask-installs.txt | tr '\n' ' ')
MACOS_OLD_VERSIONS="zsh grep vim";

ACTIONS=("symlink" "macos" "chsh-zsh" "antibody-update" "brew-packages" "cancel");
DESCRIPTIONS=(
"Symlink dotfiles to $TARGET_DIR directory."
"Install dotfiles to $TARGET_DIR directory and ensure env is set up with zsh and brew."
"Set zsh as default shell."
"Update/Install antibody."
"Install some nice brew packages (cask and regular)."
"No-op."
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

symlink()
{
  if ! check-command "zsh" ; then
    printf "No zsh found, exiting...";
    exit 1;
  fi
  symlink-all;
  exit 0;
}

GUIDED_SETUP_ACTIONS=(
"macos-prerequisites"
"symlink-all"
"antibody-self-update"
"set-zsh-default"
"brew-guided"
);
GUIDED_SETUP_DESCRIPTIONS=(
"Install macOS pre-requisites?"
"symlink dotfiles?"
"Initialize/update antibody configuration?"
"Set zsh as default shell?"
"Install brew packages?"
);

macos()
{
  if $1 ; then
    macos-prerequisites;
    symlink-all;
    antibody-self-update;
    set-zsh-default;
  else
    step_index=0
    echo -e "*** ${YELLOW}GUIDED SETUP${RESTORE} ***"
    for step in "${GUIDED_SETUP_ACTIONS[@]}"; do
      echo -e "${GREEN}${GUIDED_SETUP_DESCRIPTIONS[step_index]}${RESTORE}"
      select yn in "Yes" "No"; do
        case $yn in
          Yes ) $step && break;;
          No ) break;;
        esac
      done
      step_index=$((step_index + 1));
      printf "\n";
    done

    echo -e "\n${DARKGRAY}To load new configuration, run:${RESTORE}"
    echo -e "${GREEN}\`source $HOME/.zshrc\`${RESTORE}"
    echo -e "${YELLOW}Copy to clipboard?${RESTORE}"
    select yn in "Yes" "No"; do
      case $yn in
        Yes ) echo "source $HOME/.zshrc" | pbcopy; break;;
        No ) break;;
      esac
    done

  fi
  exit 0;
}

chsh-zsh()
{
  set-zsh-default;
  exit 0;
}

antibody-update()
{
  if ! check-command "zsh" ; then
    printf "No zsh found, exiting...";
    exit 1;
  fi
  antibody-self-update;
  exit 0;
}

cancel()
{
  exit 0;
}

brew-guided()
{
  brew-install;
  brew-cask-install;
}

brew-packages()
{
  macos-prerequisites;
  brew-install;
  brew-cask-install;
  exit 0;
}

# Helpers

print-help()
{
  printf "\nDotfiles Setup\n";
  printf "\nCommands:\n";
  i=0;
  for opt in "${ACTIONS[@]}"; do
    printf "\t%s - %s\n" "${opt}" "${DESCRIPTIONS[i]}";
    i=$((i+1));
  done
  printf "\n";
}

symlink-all()
{
  printf "Symlinking...\n";
  pushd ${TARGET_DIR} >/dev/null;
  index=0
  for opt in "${SYMLINK_SOURCE_FNAMES[@]}"; do
    printf "\t$s" "$opt";
    if [ -f "$TARGET_DIR/$opt" ] ; then
      printf "\n\tFound! Not Overriding...";
    else
      ln -s "$PATH_TO_DOTFILES/$opt" "${SYMLINK_TARGET_FNAMES[index]}";
    fi
    index=$((index + 1))
    printf "\n";
  done
  popd >/dev/null;
}

set-zsh-default()
{
  printf "Setting zsh as your default shell, this might require your password.\n\t";
  sudo chsh -s $(which zsh) $(whoami);
}

macos-prerequisites()
{
  if ! check-command "brew" ; then
    printf "No Brew found, installing...\n";
    install-brew;
  fi
  brew install $MACOS_OLD_VERSIONS;
  if ! check-command "zsh" ; then
    printf "No zsh found, installing...\n";
    install-zsh;
  fi
}

check-command()
{
  if ! command -v "$1" >/dev/null; then
    return 1;
  fi
}

install-brew()
{
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
}

install-zsh()
{
  brew install zsh;
}

install-antibody()
{
  curl -sfL git.io/antibody | sh -s - -b /usr/local/bin;
}

antibody-compinit()
{
  # This looks strange, but allows us to never compinit.
  zsh -c "(
    rm -f ${TARGET_DIR}/.zcompdump;
    autoload -Uz compinit;
    compinit;
    source ${TARGET_ANTIBODY_PATH};
    rm -f ${TARGET_DIR}/.zcompdump;
    autoload -Uz compinit;
    compinit;
    zcompile ${TARGET_DIR}/.zcompdump;
    zcompile ${TARGET_ANTIBODY_PATH};
    compinit;
  )";
}

antibody-optimize()
{
  echo "Optimizing Antibody...";
  zsh -c "(
    autoload -Uz compinit;
    compinit -C;
    pushd $(antibody home) >/dev/null;
    local LC_BACKUP=\${LC_ALL};
    local LANG_BACKUP=\${LANG};
    LC_ALL=C;
    LANG=C;
    for i in **/*.*; do
      # sed -i '' '/^[[:blank:]]*#/d' \"\$i\" 2>/dev/null; # if a line is a comment remove it, this breaks completion somehow.
      sed -i '' '/^[[:blank:]]*\$/d' \"\$i\" 2>/dev/null; # if a line is blank remove it.
    done
    for i in **/*.*; do
      zcompile \"\$i\" 2>/dev/null; # Compile the plugins.
    done;
    LC_ALL=\${LC_BACKUP};
    LANG=\${LANG_BACKUP};
  )";
}

antibody-self-update()
{
  if ! check-command "antibody" ; then
    install-antibody;
  fi
  zsh -c "autoload -Uz compinit && compinit & rm -rf $(antibody home)";
  zsh -c "autoload -Uz compinit && compinit && antibody bundle < ${ANTIBODY_PLUGIN_LIST_PATH} > ${TARGET_ANTIBODY_PATH}";
  zsh -c "autoload -Uz compinit && compinit && antibody update";
  antibody-optimize;
  antibody-compinit;
}

brew-install()
{
  xargs brew install < $PATH_TO_DOTFILES/brew/brew-installs.txt;
}

brew-cask-install()
{
  xargs brew cask install < $PATH_TO_DOTFILES/brew/brew-cask-installs.txt;
}

# Entry

set -e

main()
{
  noconfirm=false
  argument=$1

  while getopts ':fh' option; do
    case "$option" in
      h) print-help;
        cancel;
        ;;
      f) noconfirm=true
        argument="$2"
        ;;
    \?) printf "illegal option: -%s\n\n" "$OPTARG" >&2
        echo "$usage" >&2
        exit 1
        ;;
    esac
  done

  if [ "$argument" == "help" ]; then
    print-help;
    cancel;
  elif [ "$argument" == "symlink" ]; then
    symlink;
  elif [ "$argument" == "macos" ]; then
    macos $noconfirm;
  elif [ "$argument" == "chsh-zsh" ]; then
    chsh-zsh;
  elif [ "$argument" == "antibody-update" ]; then
    antibody-update;
  elif [ "$argument" == "brew-packages" ]; then
    brew-packages;
  elif [ "$argument" == "cancel" ]; then
    cancel;
  else
    print-help;
    exit 1;
  fi
}

main "$@";
