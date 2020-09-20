#!/bin/sh


if [ $(uname) = 'Darwin' ]; then
  TEXDIR=${TINYTEX_DIR:-~/Library/ManimTex}
  alias download='curl -sL'
else
  TEXDIR=${TINYTEX_DIR:-~/ManimTex}
  alias download='wget -qO-'
fi

sh -s install-base-linux.sh

rm -rf $TEXDIR
mkdir -p $TEXDIR
mv texlive/* $TEXDIR
rm -r texlive

$TEXDIR/bin/*/tlmgr install $($(<pkgs-manim.txt) | tr '\n' ' ')

if [ "$1" = '--admin' ]; then
  if [ "$2" != '--no-path' ]; then
    sudo $TEXDIR/bin/*/tlmgr path add
  fi
else
  $TEXDIR/bin/*/tlmgr path add || true
fi
