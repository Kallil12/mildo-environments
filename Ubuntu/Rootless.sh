#!/bin/bash

configure_git() {
  git config --global user.name "Romildo Oliveira Souza Júnior"
  git config --global user.email contact@mildo.me
  git config --global push.default simple
}

configure_sublime_text() {
  mkdir -p ~/.config/sublime-text-3/Packages/User/
  cp Support\ Files/Sublime\ Text/Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/
  wget -P ~/.config/sublime-text-3/Installed\ Packages/ https://packagecontrol.io/Package%20Control.sublime-package
  cp Support\ Files/Sublime\ Text/Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User/
  cp Support\ Files/Sublime\ Text/JavaScript\ \(Babel\).sublime-settings ~/.config/sublime-text-3/Packages/User/
}

clone_github_repositories() {
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "contact@mildo.me"
  ssh-add
  curl -s --user Mildo "https://api.github.com/user/keys" -d "{\"title\": \"$HOSTNAME\", \"key\": \"$(cat ~/.ssh/id_rsa.pub)\"}"
  mkdir ~/GitHub/ && cd ~/GitHub/
  curl -s --user Mildo "https://api.github.com/user/repos" | grep ssh_url | cut -d "\"" -f 4 | xargs -L1 git clone
  cd "$OLDPWD"
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
  gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'sublime_text.desktop', 'spotify_spotify.desktop', 'gnome-terminal.desktop', 'nautilus.desktop', 'virtualbox.desktop', 'firefox.desktop']"
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
  gsettings set org.gnome.shell.extensions.desktop-icons show-home false
  gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
}

hide_snap_folder() {
  echo "snap" >> ~/.hidden
  printf "\\n# Hide snap folder from ls command\\n%s\\n" "alias ls='${BASH_ALIASES[ls]} -Isnap'" >> ~/.bashrc
}

configure_git
configure_sublime_text
clone_github_repositories
customize_gnome_terminal
customize_gnome_dock
hide_snap_folder
