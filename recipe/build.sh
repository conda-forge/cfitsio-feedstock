#! /bin/bash

set -e

./configure --prefix=$PREFIX --enable-reentrant || { cat config.log ; exit 1 ; }
make stand_alone utils

# test-ish programs:
./cookbook
./speed
./testprog

make shared
make install

# NOTE: don't remove .a files! That's all we provide!
