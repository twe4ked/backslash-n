#!/bin/bash -e

main() {
  echo it works with a single file
  setup
  ./backslash-n "$FILE_1"
  diff -w <(od -a "$FILE_1") <(cat <<EOF
    0000000 f o o nl
    0000004
EOF
)
  teardown

  echo it doesn\'t add more than one trailing new line
  setup
  ./backslash-n "$FILE_1"
  ./backslash-n "$FILE_1"
  diff -w <(od -a "$FILE_1") <(cat <<EOF
    0000000 f o o nl
    0000004
EOF
)
  teardown

  echo it works with multiple files
  setup
  ./backslash-n "$FILE_1" "$FILE_2"
  diff -w <(od -a "$FILE_1") <(cat <<EOF
    0000000 f o o nl
    0000004
EOF
)
  diff -w <(od -a "$FILE_2") <(cat <<EOF
    0000000 b a r nl
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
  FILE_1="$(mktemp -t backslash-n.XXXXXX)"
  FILE_2="$(mktemp -t backslash-n.XXXXXX)"
  echo -n foo > "$FILE_1"
  echo -n bar > "$FILE_2"
}

teardown() {
  rm "$FILE_1" "$FILE_2"
}

main
