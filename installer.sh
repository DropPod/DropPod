#!/bin/bash

abort() {
  echo $'\e[31m!!!' "$@" $'\e[m'
  exit 1
}

notice() {
  echo $'\e[32m###\e[m' "$@"
}

talk() {
  echo $'\e[36m---\e[m' "$@"
}

file() {
  cat $2 > $1
}

fetch() {
  talk "Fetching ${1} from GitHub..."
  url="https://github.com/${1}/archive/${2}.tar.gz"
  curl -#fqL ${url} | tar -xf- -C ${tmp} -s /-${2}//
}

brew() {
  /usr/local/bin/brew
}

# If this script was launched with super-user permissions, we should abort now.
(( `id -u` )) || abort "Do not run this script with sudo!"

# TODO: Automatically install CLT?
[[ -x /usr/bin/cc ]] || abort "XCode's Command Line Tools are not installed.
    Install them from connect.apple.com or from inside XCode, then try again."

notice "This script will require super-user access to perform some setup work."
talk "Acquiring super-user permissions..."
sudo -k
sudo -v

tmp=$(mktemp -d -t /tmp)

fetch puppetlabs/facter 2.0.2
fetch puppetlabs/puppet 3.6.0

# TODO: This should be a series of module installs from the Forge.
talk "Setting up baseline modules..."
mkdir ${tmp}/modules

git clone --depth 1 git://github.com/DropPod/DropPod.git ${tmp}/modules/baseline
git clone --depth 1 git://github.com/DropPod/dotapp.git ${tmp}/modules/dotapp
git clone --depth 1 git://github.com/DropPod/homebrew.git ${tmp}/modules/homebrew
git clone --depth 1 git://github.com/DropPod/repository.git ${tmp}/modules/repository

talk "Creating required binstubs..."
mkdir ${tmp}/binstubs
cp ${tmp}/modules/baseline/files/puppet-wrapper.sh ${tmp}/binstubs/puppet

talk "Clearing a suitable landing site..."
sudo ${tmp}/binstubs/puppet apply -e "class { 'baseline::sudo': }"

sudo -k
notice "Super-user permissions abdicated."

talk "Launching Drop Pod..."
${tmp}/binstubs/puppet apply -e "class { 'baseline': }"
mv ${tmp} /usr/local/DropPod

if [ $# -eq 0 ]; then
  notice 'Finished!  Close this terminal (or source your ~/.profile) to take advantage'
  notice 'of your newly configured environment!'
else
  exec /usr/local/bin/drop pods "$@"
fi
