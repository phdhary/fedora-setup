sudo -n true
test $? -eq 0 || exit 1 "You need to be a root user: > sudo su"

echo "==Update System=="
sudo dnf upgrade -y;
echo "==Enabling RPM Fusion Repository=="
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm;
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;
sudo dnf upgrade -y;
echo "==Docker=="
sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine;
sudo dnf -y install dnf-plugins-core;
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo;
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin;
sudo systemctl start docker;
sudo docker run hello-world;
echo "==Installing app listed in dnf.list=="
cat dnf.list|xargs sudo dnf install -y;

echo "==NVIDIA=="
sudo dnf install akmod-nvidia -y;
sudo dnf install xorg-x11-drv-nvidia-cuda;

echo "==GIT + SSH SETUP=="
echo "Enter Your Git Username:"
read GITUSER;
git config --global user.name "${GITUSER}";

echo "Enter Your Git Email:"
read GITEMAIL;
git config --global user.email "${GITEMAIL}";

ssh-keygen -t ed25519 -C "${GITEMAIL}";
eval "$(ssh-agent -s)";
ssh-add ~/.ssh/id_ed25519;
echo "Copy text below to Github SSH settings"
cat ~/.ssh/id_ed25519.pub;
echo "Git is now configured!"

echo "==SDKMAN=="
curl -s "https://get.sdkman.io" | bash;
source "$HOME/.sdkman/bin/sdkman-init.sh";
sdk version;
sdk install java 17.0.1-open;

echo "==ZSH=="
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";

EOF
