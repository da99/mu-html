
# === {{CMD}}  name of new spec
new-spec () {
  cd "$THIS_DIR"
  local +x RAW="$(echo $@)" # squeeze whitespace
  local +x NAME="${RAW// /_}"

  local +x last="$(ls -1 specs/ | sort | tail -n 1)"
  local +x last_num=${last%%-*}
  local +x NEXT_NUM=$( printf "%03d" $(( last_num + 1)) )

  local +x DIR=specs/"$NEXT_NUM-$NAME"

  if [[ -e "$DIR" ]]; then
    echo "!!! Already exists: $DIR" >&2
    exit 2
  fi

  mkdir "$DIR"
  touch "$DIR"/input

  echo "$DIR"/input
} # === end function
