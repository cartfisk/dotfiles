#!/bin/bash

# Constants
PATH_TO_DOTFILES=$(pwd);
TARGET_DIR="$HOME";
FNAMES_TO_SYMLINK=(
".zshrc"
".gitconfig"
".tmux.conf"
".vimrc"
".wezterm.lua"
);
ACTIONS=("init" "zsh-plugins" "fonts" "cancel");
DESCRIPTIONS=(
"Install dotfiles to $TARGET_DIR."
"Install or update zsh plugins."
"Install Fonts"
"No-op."
);

# Actions

init()
{
  zsh-install;
  symlink;
  zsh-plugins;
  exit 0;
}

cancel()
{
  exit 0;
}

# Helpers

check-command()
{
  if ! command -v "$1" >/dev/null; then
    return 1;
  fi
}

zsh-install()
{
  if check-command "brew" ; then
    brew install zsh;
  elif ! check-command "zsh" ; then
    printf "No Brew found, please install zsh manually...\n";
    exit 1;
  fi
  printf "Setting zsh as your default shell, this might require your password.\n\t";
  sudo chsh -s $(which zsh) $(whoami);
}

symlink()
{
  printf "Symlinking...\n";
  pushd ${TARGET_DIR} >/dev/null;
  for opt in "${FNAMES_TO_SYMLINK[@]}"; do
    printf "\t%s" "${opt}";
    if [ -f "$TARGET_DIR/$opt" ] || [ -L "$TARGET_DIR/$opt" ] ; then
      printf "\n\tFound! Not Overriding...";
    else
      ln -s "$PATH_TO_DOTFILES/$opt";
    fi
    printf "\n";
  done
  popd >/dev/null;
}

zsh-plugins()
{
  rm -rf "${TARGET_DIR}/.zgenom"
  git clone https://github.com/jandamm/zgenom.git "${TARGET_DIR}/.zgenom"

  zsh -c "
  . ${TARGET_DIR}/.zgenom/zgenom.zsh

  zgenom load ohmyzsh/ohmyzsh lib/theme-and-appearance.zsh
  zgenom load ohmyzsh/ohmyzsh lib/completion.zsh
  zgenom load ohmyzsh/ohmyzsh lib/compfix.zsh
  zgenom load ohmyzsh/ohmyzsh lib/directories.zsh
  zgenom load ohmyzsh/ohmyzsh lib/history.zsh
  zgenom load ohmyzsh/ohmyzsh lib/key-bindings.zsh
  zgenom load ohmyzsh/ohmyzsh lib/termsupport.zsh
  zgenom load ohmyzsh/ohmyzsh plugins/gitfast
  zgenom load ohmyzsh/ohmyzsh plugins/git
  zgenom load ohmyzsh/ohmyzsh plugins/brew
  zgenom load ohmyzsh/ohmyzsh plugins/aliases
  zgenom load ohmyzsh/ohmyzsh plugins/common-aliases
  zgenom load ohmyzsh/ohmyzsh plugins/colored-man-pages
  zgenom load mafredri/zsh-async async.zsh

  zgenom load SalomonSmeke/pure- pure.zsh

  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zpm-zsh/colorize
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-history-substring-search

  zgenom load ohmyzsh/ohmyzsh lib/clipboard.zsh

  zgenom load mfaerevaag/wd

  zgenom save
  zcompile ${TARGET_DIR}/.zgenom/sources/init.zsh
  "
  if [ "$(uname)" == "Darwin" ]; then
    echo SHELL_SESSIONS_DISABLE=1 > "$TARGET_DIR/.zshenv"
  fi
}

fonts()
{
  cp -n ./assets/fonts/**/*.{ttf,otf} ~/Library/Fonts/
}

# Entry

print-help()
{
  printf "\nSalomon Smeke Dotfiles Setup\n";
  printf "\nCommands:\n";
  i=0;
  for opt in "${ACTIONS[@]}"; do
    printf "\t%s - %s\n" "${opt}" "${DESCRIPTIONS[i]}";
    i=$((i+1));
  done
  printf "\n";
}

set -e

main()
{
  if [ "$1" == "help" ]; then
    print-help;
    cancel;
  elif [ "$1" == "init" ]; then
    init;
  elif [ "$1" == "zsh-plugins" ]; then
    zsh-plugins;
  elif [ "$1" == "fonts" ]; then
    fonts;
  elif [ "$1" == "cancel" ]; then
    cancel;
  else
    print-help;
    exit 1;
  fi
}

main "$@";
