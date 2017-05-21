
# === {{CMD}}
# === {{CMD}}  specs/000-name_of_directory
edit-spec () {
  cd "$THIS_DIR"
  local +x DIR=""
  local +x ACTION=""

  if [[ ! -z "$@" ]]; then
    local +x DIR="$1"; shift
    if [[ ! -z "$@" ]]; then
      local +x ACTION="$1"; shift
    fi
  fi

  if [[ -z "$DIR" ]]; then
    local +x DIR="$(
      find -L specs -maxdepth 1 -mindepth 1 -type d | fzy || :
    )"
  fi

  if [[ -z "$DIR" ]]; then
    exit 0
  fi

  cd "$DIR"
  echo "$DIR:"
  tree --noreport

  if [[ -z "$ACTION" ]]; then
    local +x ACTION="$(echo "create\nedit" | fzy || :)"
  fi

  case "$ACTION" in
    create)
      echo "=== Create new file: "
      local +x NEW_TYPE="$(
        for O in input input/ multi-input output multi-output nil error; do
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
          echo "=== Editing: $NEW_TYPE" >&2
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
