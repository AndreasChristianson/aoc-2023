#!/usr/bin/env bash

readarray -t lines < input.txt

numPoints=0
numCards=0
declare -A cardCounts

for i in "${!lines[@]}"; do
  cardCounts[$i]=1
done

for i in "${!lines[@]}"; do
  IFS=':' read -ra sections <<< "${lines[$i]}"
  IFS='|' read -ra dataSection <<< "${sections[1]}"
  IFS=' ' read -ra targetNumbers <<< "${dataSection[0]}"
  IFS=' ' read -ra gotNumbers <<< "${dataSection[1]}"
  hits=0

  for number in "${gotNumbers[@]}"; do
    if [[ " ${targetNumbers[*]} " =~ " ${number} " ]]; then
        hits=$(( hits + 1 ))
    fi
  done
  if [ $hits -gt 0 ]; then
    for j in $(seq 1 $hits); do
      lineToAdd=$(( i + j ))
      cardCounts[$lineToAdd]=$(( ${cardCounts[$lineToAdd]} + ${cardCounts[$i]} ))
    done
  fi
  numCards=$(( cardCounts[$i] + numCards ))
  points=$(echo "2^($hits-1)" | bc)
  numPoints=$(( numPoints + points ))
  echo "card $i: $hits hits worth $points points (had ${cardCounts[$i]} copies). Scratchers so far $numCards. Points so far $numPoints."
done
