#! /bin/bash

set -e

./configure --prefix=$PREFIX --enable-reentrant || { cat config.log ; exit 1 ; }
make stand_alone shared utils

# test-ish programs:
./cookbook
./speed
./testprog

make install

# NOTE: don't remove .a files! That's all we provide!
