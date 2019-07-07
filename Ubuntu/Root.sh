#!/bin/bash

update_ubuntu() {
  apt-get update
  apt-get -y dist-upgrade
}

install_drivers() {
  ubuntu-drivers autoinstall
  prime-select intel
}

install_google_chrome() {
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
  apt-get update
  apt-get install -y google-chrome-stable
}

install_git() {
  apt-get install -y git
}

install_docker() {
  apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  apt-get update
  apt-get install -y docker-ce
  install_docker_compose
}

install_docker_compose() {
  curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}

install_sublime_text() {
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
  apt-get install -y apt-transport-https
  echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
  apt-get update
  apt-get install -y sublime-text
}

install_shellcheck() {
  apt-get install -y shellcheck
}

install_virtualbox() {
  wget -q -O - https://www.virtualbox.org/download/oracle_vbox.asc | apt-key add -
  wget -q -O - https://www.virtualbox.org/download/oracle_vbox_2016.asc | apt-key add -
  add-apt-repository "deb https://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib"
  apt-get update
  apt-get install -y "$(apt-cache search virtualbox | tail -1 | cut -d " " -f 1)"
}

install_texlive() {
  apt-get install -y texlive
}

install_spotify() {
  snap install spotify
}

remove_folders_of_home() {
  rm -rf -- ~/*
}

remove_nautilus_bookmarks() {
  rm -f ~/.config/gtk-3.0/bookmarks
}

disable_bash_history() {
  printf "\\n# Disable bash history\\nunset HISTFILE\\n" >> ~/.bashrc
  rm -f ~/.bash_history
}

show_git_branch_on_bash() {
  cat Support\ Files/bashrc >> ~/.bashrc
}

disable_bluetooth_on_boot() {
  printf '%s\n' '#!/bin/bash' 'exit 0' | tee /etc/rc.local
  chmod +x /etc/rc.local
  sed -i "/^exit 0$/i rfkill block bluetooth" /etc/rc.local
}

update_ubuntu
install_drivers
install_google_chrome
install_git
install_docker
install_docker_compose
install_sublime_text
install_shellcheck
install_virtualbox
install_texlive
install_spotify
remove_folders_of_home
remove_nautilus_bookmarks
disable_bash_history
show_git_branch_on_bash
disable_bluetooth_on_boot
