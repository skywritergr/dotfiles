echo 'You might need to change your default shell to zsh: `chsh -s /bin/zsh` (or `sudo vim /etc/passwd`)'

dir="$HOME/Documents/Projects/skywritergr"
mkdir -p $dir
cd $dir
git clone --recursive git@github.com:skywritergr/dotfiles.git
cd dotfiles
sudo bash symlink-dotfiles.sh
