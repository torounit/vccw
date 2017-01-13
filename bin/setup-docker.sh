#!/usr/bin/env bash

set -ex

apt-get update -y
apt-get install -y software-properties-common
add-apt-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y --no-install-recommends ansible ruby curl
apt-get clean

cat << EOS > hosts
[default]
localhost
EOS

ruby -ryaml -rjson -e "conf = {:vccw =>YAML.load(STDIN.read)}; conf[:vccw][:vagrant_dir] = \"/vagrant\"; puts JSON.generate(conf);" < /vagrant/provision/default.yml > test.json
curl https://raw.githubusercontent.com/vccw-team/vccw-xenial64/master/provision/playbook.yml > middleware.yaml
