#!/bin/sh

cd ${TMPDIR:-/tmp}

if [ $(uname) = 'Darwin' ]; then
  TEXDIR=${TINYTEX_DIR:-~/Library/TinyTeX}
  alias download='curl -sL'
else
  TEXDIR=${TINYTEX_DIR:-~/.TinyTeX}
  alias download='wget -qO-'
fi

download https://yihui.org/gh/tinytex/tools/install-base.sh | sh -s - "$@"

rm -rf $TEXDIR
mkdir -p $TEXDIR
mv texlive/* $TEXDIR
rm -r texlive

$TEXDIR/bin/*/tlmgr install $(download https://github.com/naveen521kk/manim-tex/raw/master/pkgs-manim.txt | tr '\n' ' ')

if [ "$1" = '--admin' ]; then
  if [ "$2" != '--no-path' ]; then
    sudo $TEXDIR/bin/*/tlmgr path add
  fi
else
  $TEXDIR/bin/*/tlmgr path add || true
fi
