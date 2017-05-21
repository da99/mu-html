
# === {{CMD}}  name of new spec
new-spec () {
  cd "$THIS_DIR"
  local +x RAW="$(echo $@)" # squeeze whitespace
  if [[ -z "$RAW" ]] ; then
    echo "!!! Missing title" >&2
    exit 2
  fi
  local +x NAME="${RAW// /_}"

  local +x last="$(ls -1 specs/ | grep -P '^\d+' | sort | tail -n 1)"
  local +x last_num=${last%%-*}
  local +x NEXT_NUM=$( printf "%03d" $(( last_num + 1)) )

  local +x DIR=specs/"${NEXT_NUM}-${NAME}"

  if [[ -e "$DIR" ]]; then
    echo "!!! Already exists: $DIR" >&2
    exit 2
  fi

  mkdir "$DIR"

  echo "$DIR"
  source "$THIS_DIR/bin/public/edit-spec/_.sh"
  edit-spec "$DIR"
  edit-spec "$DIR"
  mu-uri run-specs
} # === end function
