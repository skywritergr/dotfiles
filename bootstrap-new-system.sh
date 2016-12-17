#!/usr/bin/env zsh

# A simple script for setting up OSX dev environment.

dev="$HOME/Documents/Projects"
pushd .
mkdir -p $dev
cd $dev

echo 'Georges Macbook'
  read hostname
  echo "Setting new hostname to $hostname..."
  scutil --set HostName "$hostname"
  compname=$(sudo scutil --get HostName | tr '-' '.')
  echo "Setting computer name to $compname"
  scutil --set ComputerName "$compname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"

pub=$HOME/.ssh/id_rsa.pub
echo 'Checking for SSH key, generating one if it does not exist...'
  [[ -f $pub ]] || ssh-keygen -t rsa

echo 'Copying public key to clipboard. Paste it into your Github account...'
  [[ -f $pub ]] && cat $pub | pbcopy
  open 'https://github.com/account/ssh'

# If we on OS X, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then
  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      gem install jekyll
      brew update
      brew install htop mysql nginx nvm ruby python3 yarn
      source $(brew --prefix nvm)/nvm.sh
      nvm install --lts
  fi

  echo 'ZSH installation...'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    chsh -s /bin/zsh
    brew install autojump
    cp $(pwd)/.zshrc ~/

  echo 'Installing MacVim...'
    brew install vim
    brew install macvim --devel
    brew linkapps

  echo 'Tweaking OS X...'
    source 'etc/osx.sh'

  # http://github.com/sindresorhus/quick-look-plugins
  echo 'Installing Quick Look plugins...'
    brew tap phinze/homebrew-cask
    brew install caskroom/cask/brew-cask
    brew cask install suspicious-package quicklook-json qlmarkdown qlstephen qlcolorcode

  echo 'Installing iTerm2...'
    brew cask install iterm2
fi

echo 'Symlinking config files...'
  source 'bin/symlink-dotfiles.sh'

echo 'Applying sublime config...'
  st=$(pwd)/sublime/packages
  as="$HOME/Library/Application Support/Sublime Text 3/Packages"
  asprefs="$as/User/Preferences.sublime-settings"
  if [[ -d "$as" ]]; then
    for theme in $st/Theme*; do
      cp -r $theme $as
    done
    rm $asprefs
    cp -r $st/pm-themes $as
  else
    echo "Install Sublime Text http://www.sublimetext.com"
  fi

echo 'Applying Atom config...'
  st=$(pwd)/.atom
  as="~/"
  target="$HOME/Applications/Atom.app"
  if [[ -d "$target" ]]; then
    cp -r $st $as
  else
    echo "Install Atom"
  fi


open_apps() {
  echo 'Install apps:'
  echo 'Firefox:'
  open http://www.mozilla.org/en-US/firefox/new/
  echo 'Google Drive:'
  open https://www.google.com/drive/download/
  echo 'Chrome:'
  open https://www.google.com/intl/en/chrome/browser/
  echo 'Sequel Pro:'
  open http://www.sequelpro.com
  echo 'Skype:'
  open http://www.skype.com/en/download-skype/skype-for-computer/
  echo 'Spotify':
  open https://www.spotify.com/uk/download/other/
  echo 'Transmission:'
  open http://www.transmissionbt.com
  echo 'VLC:'
  open http://www.videolan.org/vlc/index.html
  echo 'Atom:'
  open https://atom.io/
  echo 'Sketch:'
  open https://www.sketchapp.com/
  echo 'Tunnelblink:'
  open https://tunnelblick.net/downloads.html
}

echo 'Should I give you links for system applications (e.g. Skype, Atom, VLC)?'
echo 'n / y'
read give_links
[[ "$give_links" == 'y' ]] && open_apps

popd
