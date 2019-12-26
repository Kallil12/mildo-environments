#!/bin/bash

update_ubuntu() {
  apt-get update
  apt-get -y dist-upgrade
}

install_git() {
  apt-get install -y git
}

install_docker() {
  apt-get install -y docker.io
}

install_virtualbox() {
  apt-get install -y virtualbox
}

install_spotify() {
  snap install spotify
}

install_axel() {
  apt-get install -y axel
}

install_telegram() {
  snap install telegram-desktop
}

install_wine() {
  apt-get install -y wine
}

install_whatsapp() {
  snap install whatsdesk
}

install_dropbox() {
  apt-get install -y libpango1.0-0 libpangox-1.0-0
  wget -q -O dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb
  dpkg -i dropbox.deb
  rm dropbox.deb
}

install_asdf-dependencies() {
  apt-get install -y automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev unzip curl
# Python dependencies
  apt-get install -y zlib1g-dev libbz2-dev libsqlite3-dev
}

install_vscode() {
  snap install --classic code
}

install_gnome_shell_integration() {
  apt-get -y install chrome-gnome-shell
}

remove_folders_of_home() {
  rm -rf -- /home/mildo/*
}

remove_nautilus_bookmarks() {
  rm -f /home/mildo/.config/gtk-3.0/bookmarks
}

disable_bash_history() {
  printf "\\n# Disable bash history\\nunset HISTFILE\\n" >> /home/mildo/.bashrc
  rm -f /home/mildo/.bash_history
}

show_git_branch_on_bash() {
  cat bashrc >> /home/mildo/.bashrc
}

disable_bluetooth_on_boot() {
  printf '%s\n' '#!/bin/bash' 'exit 0' | tee /etc/rc.local
  chmod +x /etc/rc.local
  sed -i "/^exit 0$/i rfkill block bluetooth" /etc/rc.local
}

update_ubuntu
install_git
install_docker
install_virtualbox
install_spotify
install_axel
install_telegram
install_wine
install_whatsapp
install_dropbox
install_asdf-dependencies
install_vscode
install_gnome_shell_integration
remove_folders_of_home
remove_nautilus_bookmarks
disable_bash_history
show_git_branch_on_bash
disable_bluetooth_on_boot
