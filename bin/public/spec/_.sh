
# === {{CMD}}  new  name-of-spec
spec () {
  source "$THIS_DIR/dev/paths.sh"
  SPEC_TMP="$THIS_DIR/tmp/spec/run"
  PATH="$PATH:$THIS_DIR/../sh_color/bin/sh_color"

  case "$1" in
    dirs-must-match)
      shift
      input="$(realpath "$1")"; shift
      output="$(realpath "$1")"; shift

      IFS=$'\n'
      cd "$input"
      for FILE in $(find -L "." -type f); do
        cd "$output"
        if [[ ! -e "$FILE" ]]; then
          echo "!!! File in input, but not in output: $FILE" >&2
          exit 2
        fi
        if ! diff --ignore-trailing-space "$input/$FILE" "$FILE" ; then
          echo "!!! File input != output: $FILE"
          exit 2
        fi
      done

      cd "$output"
      for FILE in $(find -L "." -type f); do
        cd "$input"
        if [[ ! -e "$FILE" ]]; then
          echo "!!! File in output, but not in input: $FILE" >&2
          exit 2
        fi
      done

      sh_color GREEN "=== {{Passed}}: BOLD{{$input}}"
      ;;

    bin-path)
      echo "$SPEC_TMP"/mu-html.spec
      ;;

    compile)
      mkdir -p "$SPEC_TMP"
      cd "$SPEC_TMP"
      crystal build "$THIS_DIR/spec/mu-html.spec.cr"
      echo "=== Wrote: $SPEC_TMP/mu-html.spec"
      ;;

    new)
      shift
      cd "$THIS_DIR"

      mkdir -p spec
      cd "spec"

      local +x NAME="$(echo $@ | tr -s ' ' | tr ' ' '-')"
      local +x COUNT=$(find "$THIS_DIR"/spec -type d -iname "*-*" | wc -l | xargs -I NUM printf "%02d\n" NUM)

      local +x OLD_NAME="$({ ls -1 | grep -P "^[0-9]+-$NAME$" 2>/dev/null | sort --version-sort | tail -n 1; } || :)"

      if [[ -z "$OLD_NAME" ]]; then
        local +x NEW_NAME="$COUNT-$NAME"
      else
        local +x NEW_NAME="$OLD_NAME"
      fi

      mkdir -p "$NEW_NAME"
      cd "$NEW_NAME"
      mkdir -p input
      touch input/input.html

      mkdir -p output
      touch output/output.html

      cd "$THIS_DIR"
      tree "spec/$NEW_NAME"
      ;;
    *)
      echo "!!! Invalid action: $@" >&2
      exit 2
      ;;
  esac
} # === end function
