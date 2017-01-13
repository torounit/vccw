#!/usr/bin/env bash

set -ex

apt-get update -y
apt-get install -y software-properties-common
add-apt-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y --no-install-recommends ansible ruby curl sudo
apt-get clean

cat << EOS > /home/ubuntu/hosts
[default]
localhost
EOS

groupadd -g 1000 ubuntu
useradd -g ubuntu -G sudo -m -s /bin/bash ubuntu
echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ruby -ryaml -rjson -e "conf = {:vccw =>YAML.load(STDIN.read)}; conf[:vccw][:vagrant_dir] = \"/vagrant\"; puts JSON.generate(conf);" < /vagrant/provision/default.yml > /home/ubuntu/test.json
curl https://raw.githubusercontent.com/vccw-team/vccw-xenial64/master/provision/playbook.yml > /home/ubuntu/middleware.yaml

chown -R ubuntu:ubuntu /home/ubuntu
