#!/bin/bash -e

main() {
  build

  echo it works with a single file
  setup
  ./backslash-n "$FILE_1"
  diff -w <(hexdump "$FILE_1") <(cat <<EOF
    0000000 66 6f 6f 0a
    0000004
EOF
)
  teardown

  echo it doesn\'t add more than one trailing new line
  setup
  ./backslash-n "$FILE_1"
  ./backslash-n "$FILE_1"
  diff -w <(hexdump "$FILE_1") <(cat <<EOF
    0000000 66 6f 6f 0a
    0000004
EOF
)
  teardown

  echo it works with multiple files
  setup
  ./backslash-n "$FILE_1" "$FILE_2"
  diff -w <(hexdump "$FILE_1") <(cat <<EOF
    0000000 66 6f 6f 0a
    0000004
EOF
)
  diff -w <(hexdump "$FILE_2") <(cat <<EOF
    0000000 62 61 72 0a
    0000004
EOF
)
  teardown

  echo it returns error if file not found
  diff -w <(./backslash-n no-file) <(cat <<EOF
    ./backslash-n: could not open file: no-file
EOF
)

  echo it returns usage
  diff -w <(./backslash-n) <(echo "usage: ./backslash-n [file ...]")
}

setup() {
  FILE_1="$(mktemp -t backslash-n)"
  FILE_2="$(mktemp -t backslash-n)"
  echo -n foo > "$FILE_1"
  echo -n bar > "$FILE_2"
}

teardown() {
  rm "$FILE_1" "$FILE_2"
}

build() {
  make -s
}

main
