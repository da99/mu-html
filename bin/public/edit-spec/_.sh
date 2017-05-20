
# === {{CMD}}
edit-spec () {
  cd "$THIS_DIR"
  local +x DIR="$(
    find -L specs -maxdepth 1 -mindepth 1 -type d | fzy || :
  )"

  if [[ -z "$DIR" ]]; then
    exit 0
  fi

  cd "$DIR"
  echo "$DIR:"
  tree --noreport

  local +x ACTION="$(echo "create\nedit" | fzy || :)"

  case "$ACTION" in
    create)
      echo "=== Creating: "
      local +x NEW_TYPE="$(
        for O in input input/ multi-input output nil error; do
          echo $O
        done | fzy || :
      )"
      if [[ -e "$NEW_TYPE" ]]; then
        echo "=== Already exists: $NEW_TYPE"
        exit 0
      fi
      case "$NEW_TYPE" in
        "")
          exit 0
          ;;
        */)
          echo "=== Creating dir: $NEW_TYPE" >&2
          mkdir -p "$NEW_TYPE"
          ;;
        *)
          echo "=== Touching: $NEW_TYPE" >&2
          $EDITOR "$NEW_TYPE"
          ;;
      esac
      ;;

    edit)
      echo "=== Editing..."
      tree -a -f -i -n --noreport | tail -n+2 | fzy | {
        read -r NEW_NAME
        $EDITOR "$NEW_NAME"
      } || :
      ;;
  esac

} # === end function
