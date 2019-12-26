#!/bin/bash

configure_git() {
  git config --global user.name "Romildo Oliveira Souza Júnior"
  git config --global user.email contact@mildo.me
  git config --global push.default simple
}

clone_github_repositories() {
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "contact@mildo.me"
  ssh-add
  curl -s --user Mildo "https://api.github.com/user/keys" -d "{\"title\": \"$HOSTNAME\", \"key\": \"$(cat ~/.ssh/id_rsa.pub)\"}"
  mkdir ~/GitHub/ && cd ~/GitHub/
  curl -s --user Mildo "https://api.github.com/user/repos" | grep ssh_url | cut -d "\"" -f 4 | xargs -L1 git clone
  cd "$OLDPWD"
}

customize_gnome() {
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
}

customize_gnome_terminal() {
  TERMINAL_PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default)
  TERMINAL_PROFILE=${TERMINAL_PROFILE:1:-1}
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${TERMINAL_PROFILE}"/ use-theme-colors false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${TERMINAL_PROFILE}"/ palette "['rgb(0,0,0)', 'rgb(205,0,0)', 'rgb(0,205,0)', 'rgb(205,205,0)', 'rgb(0,0,205)', 'rgb(205,0,205)', 'rgb(0,205,205)', 'rgb(250,235,215)', 'rgb(64,64,64)', 'rgb(255,0,0)', 'rgb(0,255,0)', 'rgb(255,255,0)', 'rgb(0,0,255)', 'rgb(255,0,255)', 'rgb(0,255,255)', 'rgb(255,255,255)']"
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${TERMINAL_PROFILE}"/ foreground-color "rgb(170,170,170)"
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${TERMINAL_PROFILE}"/ background-color "rgb(0,0,0)"
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${TERMINAL_PROFILE}"/ use-system-font false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"${TERMINAL_PROFILE}"/ use-theme-transparency false
}

customize_gnome_dock() {
  gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'code_code.desktop', 'spotify_spotify.desktop', 'gnome-terminal.desktop', 'nautilus.desktop', 'virtualbox.desktop', 'firefox.desktop', 'telegram-desktop_telegramdesktop.desktop', 'whatsdesk_whatsdesk.desktop']"
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
  gsettings set org.gnome.shell.extensions.desktop-icons show-home false
  gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
}

hide_snap_folder() {
  echo "snap" >> ~/.hidden
  printf "\\n# Hide snap folder from ls command\\n%s\\n" "alias ls='${BASH_ALIASES[ls]} -Isnap'" >> ~/.bashrc
}

install_asdf() {
  git clone https://github.com/asdf-vm/asdf.git /home/mildo/.asdf
  cd /home/mildo/.asdf && git checkout "$(git describe --abbrev=0 --tags)" && cd -
  printf "\\n# Activate asdf-vm\\nsource ~/.asdf/asdf.sh\\nsource ~/.asdf/completions/asdf.bash\\n" >> /home/mildo/.bashrc
  source ~/.asdf/asdf.sh
}

install_asdf_plugins() {
  asdf plugin-add python
  asdf install python 3.8.0
  asdf global python 3.8.0
  pip install --upgrade pip
  printf "\\nexport PIP_REQUIRE_VIRTUALENV=true\\n" >> ~/.bashrc
}

install_docker_compose() {
  pip install docker-compose
  asdf reshim
}

install_vscode_settings_sync() {
  code --install-extension shan.code-settings-sync
}

configure_git
clone_github_repositories
customize_gnome
customize_gnome_terminal
customize_gnome_dock
hide_snap_folder
install_asdf
install_asdf_plugins
install_docker_compose
install_vscode_settings_sync
