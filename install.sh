echo "APT DAN FLATPAK POST INSTALL"

set -eu -o pipefail


sudo -n true
test $? -eq 0 || exit 1 "harus sudo lah bro"

echo "===APP PENTING==="
echo "update repository dulu"
sudo apt-get update -y
echo "update package ke latest"
sudo apt-get upgrade -y

echo "lanjut nginstall yang ada di apt.list"
cat apt.list|xargs sudo apt-get -y install

echo "lanjut lagi flatpak nih sesuai yang ada di flatpak.list"
cat flatpak.list|xargs sudo flatpak install -y

echo "===GIT SETUP==="
echo "Masukkan Username git:"
read GITUSER;
git config --global user.name "${GITUSER}"	

echo "Masukkan Email git:"
read GITEMAIL;
git config --global user.email "${GITEMAIL}"

echo "Oke git udah ter config"

echo "===FLUTTER==="
git clone https://github.com/flutter/flutter.git -b stable development/flutter
echo "export PATH="$PATH:`pwd`/development/flutter/bin" >> .zshrc
exec zsh
flutter precache

echo "===SDKMAN==="
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version
sdk install java 17.0.1-open



