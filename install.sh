echo "APT DAN FLATPAK POST INSTALL"



sudo -n true
test $? -eq 0 || exit 1 "you need to be a root user"

echo "===Important App==="
echo "Updating apt repository"
sudo apt-get update -y
echo "Updating apt package to the latest"
sudo apt-get upgrade -y

echo "Installing app listed in apt.list"
cat apt.list|xargs sudo apt-get -y install

#echo "Installing app listed in flatpak.list"
#FLATPAKAPPS=$(cat flatpak.list)
#flatpak install $FLATPAKAPPS

echo "===GIT SETUP==="
echo "Enter Git Username:"
read GITUSER;
git config --global user.name "${GITUSER}"	

echo "Enter Git Email:"
read GITEMAIL;
git config --global user.email "${GITEMAIL}"

ssh-keygen -t ed25519 -C "${GITEMAIL}"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "copy text below to github ssh"
cat ~/.ssh/id_ed25519.pub

echo "Git is now configured"

echo "===FLUTTER==="
echo "Installing Flutter"
sudo snap install flutter --classic
flutter precache
echo "===ANDROID STUDIO==="
echo "Installing Android Studio"
sudo snap install android-studio --classic


echo "===SDKMAN==="
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version
sdk install java 17.0.1-open

echo "===ZSH==="
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


EOF
