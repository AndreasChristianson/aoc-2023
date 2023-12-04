#!/usr/bin/env bash

set -x

echo "hello world"

say_hello () {
  echo "hello $0"
}

fib () {
  if [ $1 -le 0 ];
  then
    echo 1
  elif [ $1 -eq 1 ];
  then
    echo 1
  else
    echo $(($(fib $(($1-2))) + $(fib $(($1 - 1))) ))
  fi
}

readarray -t lines < example.txt

echo "${lines[@]}"

say_hello "$@"

fib 10