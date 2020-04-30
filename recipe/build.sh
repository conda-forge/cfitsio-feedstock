#! /bin/bash

set -e

if [ $(uname) = Darwin ] ; then
    # Needed to get 'union semun' definition used in drvrsmem.c:
    export CFLAGS="$CFLAGS -D_DARWIN_C_SOURCE"
    export LIBS_PREPEND="-Wl,-reexport_library,$PREFIX/lib/libz.dylib"
fi

./configure --prefix=$PREFIX --with-bzip2 --enable-reentrant || { cat config.log ; exit 1 ; }

make shared utils
make install

# Test-ish programs:
$PREFIX/bin/cookbook
$PREFIX/bin/speed
# Actual test suite as described in docs/cfitsio.doc
$PREFIX/bin/testprog > testprog.lis
diff testprog.lis testprog.out
cmp testprog.fit testprog.std

rm -f $PREFIX/bin/cookbook $PREFIX/bin/speed $PREFIX/bin/testprog

# check symbol exports on osx
if [ $(uname) = Darwin ]; then
    ${OTOOL} -l $PREFIX/lib/libcfitsio.dylib | grep "LC_REEXPORT_DYLIB"
fi
    
