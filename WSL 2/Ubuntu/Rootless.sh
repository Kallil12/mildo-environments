#!/bin/bash

configure_git() {
  git config --global user.name "Romildo Oliveira Souza Júnior"
  git config --global user.email contact@mildo.me
  git config --global push.default simple
}

clone_github_repositories() {
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "contact@mildo.me"
  eval `ssh-agent -s`
  ssh-add
  curl -s --user Mildo "https://api.github.com/user/keys" -d "{\"title\": \"$HOSTNAME\", \"key\": \"$(cat ~/.ssh/id_rsa.pub)\"}"
  mkdir ~/GitHub/ && cd ~/GitHub/
  curl -s --user Mildo "https://api.github.com/user/repos" | grep ssh_url | cut -d "\"" -f 4 | xargs -L1 git clone
  cd "$OLDPWD"
}

install_asdf() {
  git clone https://github.com/asdf-vm/asdf.git /home/mildo/.asdf
  cd /home/mildo/.asdf && git checkout "$(git describe --abbrev=0 --tags)" && cd -
  printf "\\n# Activate asdf-vm\\nsource ~/.asdf/asdf.sh\\nsource ~/.asdf/completions/asdf.bash\\n" >> /home/mildo/.bashrc
  source ~/.asdf/asdf.sh
}

install_asdf_plugins() {
  asdf plugin-add python
  asdf install python 3.8.1
  asdf global python 3.8.1
  pip install --upgrade pip setuptools
  printf "\\nexport PIP_REQUIRE_VIRTUALENV=true\\n" >> ~/.bashrc
}

show_git_branch_on_bash() {
  cat bashrc >> /home/mildo/.bashrc
}

configure_git
clone_github_repositories
install_asdf
install_asdf_plugins
show_git_branch_on_bash
