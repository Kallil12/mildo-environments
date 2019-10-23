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
  curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}

install_sublime_text() {
  snap install --classic sublime-text
}

install_shellcheck() {
  apt-get install -y shellcheck
}

install_virtualbox() {
  apt-get install -y virtualbox
}

install_spotify() {
  snap install spotify
}

install_python() {
  apt-get install -y python3 python3-pip
  pip3 install virtualenv virtualenvwrapper
  printf "\\n# Activate virtualenvwrapper\\nexport VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3\\nexport WORKON_HOME=~/.virtualenvs\\nsource /usr/local/bin/virtualenvwrapper.sh\\nexport PIP_REQUIRE_VIRTUALENV=true\\n" >> /home/mildo/.bashrc
}

install_axel() {
  apt-get install -y axel
}

install_telegram() {
  snap install telegram-desktop
}

install_wine() {
  wget -q -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
  add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -sc) main"
  apt-get update
  apt-get install -y winehq-staging
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
  cat Support\ Files/bashrc >> /home/mildo/.bashrc
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
install_spotify
install_python
install_axel
install_telegram
install_wine
remove_folders_of_home
remove_nautilus_bookmarks
disable_bash_history
show_git_branch_on_bash
disable_bluetooth_on_boot
