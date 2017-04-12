
# === {{CMD}}  new  name-of-spec
spec () {
  case "$1" in
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
