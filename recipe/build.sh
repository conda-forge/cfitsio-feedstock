#! /bin/bash

set -xeuo pipefail

extra_cmake_args=(
    -GNinja
    -DTESTS=On
    -DUTILS=On
    -DUSE_BZIP2=On
    -DUSE_CURL=On
    -DUSE_PTHREADS=On
)

if [ $(uname) = Darwin ] ; then
    # Needed to get 'union semun' definition used in drvrsmem.c:
    export CXXFLAGS="$CXXFLAGS -D_DARWIN_C_SOURCE"
fi

# The Autotools-based build supports a few additional features, like support for
# Globus gsiftp. Unless we decide that we need one of those, the CMake build is
# maintained and is nicer to deal with.

mkdir build
cd build
cmake ${CMAKE_ARGS} "${extra_cmake_args[@]}" $SRC_DIR
ninja -v
ninja install

if [ ${CONDA_BUILD_CROSS_COMPILATION:-0} -eq 0 ] ; then
    ./cookbook

    ./TestProg >testprog.lis
    diff testprog.lis ../testprog.out
    cmp testprog.fit ../testprog.std
fi
