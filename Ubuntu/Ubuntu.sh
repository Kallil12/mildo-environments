#!/bin/bash

run_scripts() {
  sudo ./Root.sh
  bash -i ./Rootless.sh
}

docker_as_non_root() {
  sudo usermod -aG docker "$USER"
}

post_scripts_cleaning() {
  sudo apt-get -y --purge autoremove
  sudo apt-get -y clean
}

disable_scripts_history() {
  unset HISTFILE
}

run_scripts
docker_as_non_root
post_scripts_cleaning
disable_scripts_history
