#!/bin/bash

# Kicks off Puppet operations with a local installation of the toolchain.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
RUBYLIB=${DIR}/facter/lib:${DIR}/puppet/lib ${DIR}/puppet/bin/puppet "$@" --modulepath=${DIR}/modules
