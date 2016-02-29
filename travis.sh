#!/bin/sh

set -x
uname -a

cd watchman

set -e
PATH=$PWD:$PATH

if [ -z "$TRAVIS_PYTHON_VERSION" ]; then
  export PYTHON=/usr/bin/python2.7;
else
  export PYTHON=/usr/bin/python$TRAVIS_PYTHON_VERSION;
fi

./autogen.sh
./configure --with-python --without-ruby
make clean
make

rm -rf /tmp/watchman*
rm -rf /var/tmp/watchmantest*
TMPDIR=/var/tmp
TMP=/var/tmp
export TMPDIR TMP

if ! make integration ; then
  find /var/tmp/watchmantest* -name log | xargs cat
  exit 1
fi

INST_TEST=/tmp/install-test
test -d $INST_TEST && rm -rf $INST_TEST
make DESTDIR=$INST_TEST install
find $INST_TEST

exit 0
