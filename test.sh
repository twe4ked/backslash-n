#!/bin/bash -e

main() {
  make

  echo -n foo > test.txt

  state

  ./backslash-n test.txt

  state

  ./backslash-n test.txt

  state
}

state() {
  echo
  hexdump test.txt
}

main
