#!/usr/bin/env bash

#set -x

readarray -t lines < input.txt

sum=0
declare -A stored

for i in "${!lines[@]}"; do
  stored[$i]=1
done

for i in "${!lines[@]}"; do
  IFS=':' read -ra dataSections <<< "${lines[$i]}"
  IFS='|' read -ra dataSection <<< "${dataSections[1]}"
  IFS=' ' read -ra targetNumbers <<< "${dataSection[0]}"
  IFS=' ' read -ra gotNumbers <<< "${dataSection[1]}"
  hits=0

  for number in "${gotNumbers[@]}"; do
    if [[ " ${targetNumbers[*]} " =~ " ${number} " ]]; then
        hits=$(( hits + 1 ))
    fi
  done
  if [ $hits -gt 0 ]; then
    for j in $(seq 1 $hits);  do
      lineToAdd=$(( i + j ))
      stored[$lineToAdd]=$(( ${stored[$lineToAdd]} + ${stored[$i]} ))
    done
  fi
  sum=$(( stored[$i] + sum ))
  echo "scratchcard $i: $hits hits, ${stored[$i]} copies. Scratchers so far: $sum."
done

echo "tada: $sum!"
