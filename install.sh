echo "APT DAN FLATPAK POST INSTALL"

set -eu -o pipefail


sudo -n true
test $? -eq 0 || exit 1 "you need to be a root user"

echo "===Important App==="
echo "Updating apt repository"
sudo apt-get update -y
echo "Updating apt package to the latest"
sudo apt-get upgrade -y

echo "Installing app listed in apt.list"
cat apt.list|xargs sudo apt-get -y install

echo "Installing app listed in flatpak.list"
FLATPAKAPPS=$(cat flatpak.list)
flatpak install $FLATPAKAPPS

echo "===GIT SETUP==="
echo "Enter Git Username:"
read GITUSER;
git config --global user.name "${GITUSER}"	

echo "Enter Git Email:"
read GITEMAIL;
git config --global user.email "${GITEMAIL}"

echo "Git is now configured"

echo "===FLUTTER==="
echo "Installing Flutter"
git clone https://github.com/flutter/flutter.git -b stable development/flutter

echo 'export PATH="$PATH:`pwd`/development/flutter/bin"' >> .zshrc
exec zsh

flutter precache

echo "===SDKMAN==="
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version
sdk install java 17.0.1-open

EOF
