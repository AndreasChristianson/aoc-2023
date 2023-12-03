#!/usr/bin/env bash

for d in day*/ ; do
  echo "## $d ##"
    make -C "$d" run
done