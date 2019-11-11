# dotfiles

[dotfiles](https://askubuntu.com/questions/94780/what-are-dot-files), and some scripts to automate macos setup.

inspired by [Salomon Smeke](https://github.com/salomonsmeke)'s [dotfiles](https://github.com/salomonsmeke/dotfiles) & [gmoe](https://github.com/gmoe)'s [dotfiles](https://github.com/gmoe/dotfiles).

## batteries

[Brew](https://brew.sh) - 👌 macos package manager.

[Zsh](http://www.zsh.org) - 💪 shell.

[Antibody](https://getantibody.github.io) - 🏎️ plugin manager for zsh.

[Oh My Zsh](https://ohmyz.sh) - 🙏 zsh config framework and all around place-where-zsh-stuff-lives.

[Various zsh plugins](.zsh_antibody_plugins.txt) - 📖 Full list below!

<details>
  <summary>these ones</summary>

  ## Lib stuff that other plugins depend on
  [robbyrussell/lib](https://github.com/robbyrussell/oh-my-zsh/tree/master/lib) - Quite a few of these actually.
  [SalomonSmeke/grep](https://github.com/SalomonSmeke/oh-my-zsh/blob/master/lib/grep.zsh) - Faster copy from robby/lib.

  ## Neato plugins
  [zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - "Fish shell-like syntax highlighting for Zsh."
  [robbyrussell/plugins/colored-man-pages](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/colored-man-pages) - Color for man pages.
  [zpm-zsh/colorize](https://github.com/zpm-zsh/colorize) - Default utilities to color output.
  [robbyrussell/plugins/gitfast](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/gitfast) - Fast and up to date git plugin.
  [MichaelAquilina/zsh-you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use) - Tells you when you have an alias set up for something you just did.
  [robbyrussell/themes/theunraveler.zsh-theme](https://github.com/robbyrussell/oh-my-zsh/tree/master/themes/theunraveler.zsh-theme) - A _BEAUTIFUL_ zsh theme. Honestly the best one.
  [robbyrussell/plugins/wd](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/wd) - Warp Directory. Like all those CD aliases you have, but good.
</details>

## usage

**go somewhere you dont mind this repo living in:**
```shell
cd ${FOLDER_WHERE_DOTFILES_WILL_LIVE_FOREVER_PROBABLY_TILDE_IDK_IM_NOT_YOUR_BOSS}
```

**clone the repo:**
```shell
git clone https://github.com/cartfisk/dotfiles.git
```

**go into the repo:**
```shell
cd dotfiles
```

**make desired modifications**

Upon first setup, you may want to modify what will be installed via the setup script.

[zsh add-ons](.zsh_antibody_plugins.txt)

[brew packages](brew/brew-installs.txt)

[brew cask packages](brew/brew-cask-installs.txt)

```shell
vim .zsh_antibody_plugins.txt
vim ./brew/brew-installs.txt
vim ./brew/brew-cask-installs.txt
```

**run guided setup (mac):**
_note: this will also update zsh, grep and vim. the built-in macos versions are quite outdated_.
```shell
./setup.sh macos
```

_optionally: run with `-f` flag (`./setup.sh -f macos`) to skip guided setup and run without prompts_

## additional options

**symlinking:**
```shell
./setup.sh symlink
```

**update antibody/modules:**
```shell
./setup.sh antibody-update
```

**install some brew 🍺 packages:**
<details>
  <summary>these ones</summary>

  ## tap

  [ack](https://github.com/beyondgrep/ack3) - 🧞 Excellent and human search tool.

  [asciinema](https://asciinema.org) - 📷 Record your shell and share it! [Get started with this, a guide](https://asciinema.org/docs/how-it-works).

  [bat](https://github.com/sharkdp/bat) - 🦇 Who knew you needed a "better `cat`"?

  [exa](https://github.com/ogham/exa) - 🤖 Same, but for `ls`.

  [grep](https://www.gnu.org/software/grep/) - 🔎 GNU grep, egrep and fgrep.

  [htop](https://github.com/hishamhm/htop) - 📊 Same, but for `top`.

  [nvm](https://github.com/nvm-sh/nvm) - 🗂️ Manage node versions like a sane person.

  [python](https://github.com/python/cpython) - 🐍 A programming/scripting language that ships with everything, but we want a newer version.

  [sl](https://github.com/mtoyoda/sl) - 🚂 ls(1) backwards don't do it.

  [sox](https://github.com/mtoyoda/sl) - 🎸 CLI for transcoding & analyzing audio files.

  [ssh-copy-id](https://www.openssh.com/) - 🔑 Add a public key to a remote machine's authorized_keys file.

  [thefuck](https://github.com/nvbn/thefuck) - 😡 Programatically correct mistyped console commands.

  [tmux](https://github.com/tmux/tmux) - 🎛️ Screen, but better. Look [here for a cheatsheet](http://tmuxcheatsheet.com).

  [tree](http://mama.indstate.edu/users/ice/tree/) - 🌳 ~Look like a l33t hacker~ Print out a directory's structure.

  [vim](https://www.vim.org) - 👩‍🏫 Text editor of the past and future. [Hey nice another cheatsheet](https://vim.rtorr.com).

  [wget](https://www.gnu.org/software/wget/) - 📡 Internet file retriever.


  ## cask

  [appcleaner](https://freemacsoft.net/appcleaner/) - 🧹 Remove all traces of applications.

  [BetterZip](https://macitbetter.com/downloads/) - 📦 Handle archives with tact.

  [calibre](https://calibre-ebook.com) - 📚 Ugly but amazing ebook manager.

  [clipgrab](clipgrab) - 📹 Download videos from YouTube and other video sites.

  [disk-inventory-x](http://www.derlien.com) - 💽 Neat viz tool that shows you where your storage space went.

  [image-optim](https://imageoptim.com/mac) - 🖼️ I think they put it best: "ImageOptim makes images load faster".

  [iterm2](https://www.iterm2.com/) - 💻 Full featured terminal.

  [max](https://sbooth.org/Max/) - 💿 An application for creating high-quality audio files in various formats, from compact discs or files.

  [onyx](https://www.titanium-software.fr/en/onyx.html) - ⛏️ MacOS toolkit.

  [slack](https://slack.com) - 💬 Work chat.

  [spotify](https://spotify.com) - 🎧 Streaming music.

  [transmission-remote-gui](https://spotify.com) - ⬇  A feature rich cross platform GUI for the Transmission BitTorrent client.

  [visual-studio-code](https://code.visualstudio.com) - ⌨️ Code editing. Redefined.

  [vlc](https://www.videolan.org/vlc/index.html) - 📺 Masterful media player (Remember the `codec` days? lol).

  **quicklook extensions:**

  [QLColorCode](https://github.com/anthonygelibert/QLColorCode) - 💡 Preview source code files with syntax highlighting.

  [QLStephen](https://github.com/whomwah/qlstephen) - 🗒 Preview plain text files without or with unknown file extension. Example: README, CHANGELOG, index.styl, etc.

  [QLMarkdown](https://github.com/toland/qlmarkdown) - 🖍 Preview Markdown files.

  [QuickLookJSON](http://www.sagtau.com/quicklookjson.html) - 🥌 Preview JSON files.

  [qlImageSize](https://github.com/Nyx0uf/qlImageSize) - 🖼 Display image size and resolution.

  [Suspicious Package](http://www.mothersruin.com/software/SuspiciousPackage/) - 🕵️‍♂️ Preview the contents of a standard Apple installer package.

  [QuickLookASE](https://github.com/rsodre/QuickLookASE) - 🎨 Preview Adobe ASE Color Swatches generated with Adobe Photoshop, Adobe Illustrator, [Adobe Color CC](https://color.adobe.com), [Spectrum](http://www.eigenlogik.com/spectrum/mac), [COLOURlovers](http://www.colourlovers.com), [Prisma](http://www.codeadventure.com), among many others...

  [QLVideo](https://github.com/Marginal/QLVideo) - 📼 Preview most types of video files, as well as their thumbnails, cover art and metadata.

  [QLPrettyPatch](https://github.com/Marginal/QLVideo) - 🔌 QuickLook generator for patch files.

  [quicklook-csv](https://github.com/p2/quicklook-csv) - 📈 Preview CSV files.


</details>

```shell
./setup.sh brew-packages
```

**print usage:**
```shell
./setup.sh help
```

**print usage but very [cryptographically secure](https://www.youtube.com/watch?v=KEkrWRHCDQU):**
```shell
./setup.sh $RANDOM
```

## ech

[Copyright (c)](https://github.com/cartfisk/dotfiles/blob/master/LICENSE) 2019 [Carter Thomas Konz](https://cartfisk.com) with an [MIT License](https://github.com/cartfisk/dotfiles/blob/master/LICENSE)
