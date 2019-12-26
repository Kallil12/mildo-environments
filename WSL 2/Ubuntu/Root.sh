#!/bin/bash

update_ubuntu() {
  apt-get update
  apt-get -y dist-upgrade
}

install_docker() {
  apt-get install -y docker.io
}

install_asdf-dependencies() {
  apt-get install -y automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev unzip curl
  apt-get install -y libbz2-dev libsqlite3-dev
}

update_ubuntu
install_docker
install_asdf-dependencies
