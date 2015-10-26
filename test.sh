#!/bin/bash -e

main() {
  make

  echo -n foo > test.txt
  echo -n bar > test2.txt

  state

  ./backslash-n test.txt

  state

  ./backslash-n test.txt test2.txt

  state
}

state() {
  echo
  hexdump test.txt
  hexdump test2.txt
}

main
