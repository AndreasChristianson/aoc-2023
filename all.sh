#!/usr/bin/env bash

if [[ $* == *--time* ]]; then
  timing="time"
fi

if [[ $* == *--no-output* ]]; then
  redirect=/dev/null
else
  redirect=/dev/tty
fi

for d in day*/ ; do
  echo "## $d ##"
  TIME="%E" $timing make -C "$d" run >$redirect
done