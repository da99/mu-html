
# === {{CMD}}
watch () {

  PATH="$PATH:$THIS_DIR/../my_crystal_lang/progs/latest-crystal/bin"
  PATH="$PATH:$THIS_DIR/../my_crystal_lang/progs/latest-shards/bin"

  if [[ ! -z "$@" ]]; then
    echo "=== Compiling... $(date "+%H:%M:%S") ..." >&2
    bin/mu-html dev
    sleep 0.5
    tmp/mu-html --file spec/00-it-works/input/input.json
    echo "============================================="
    echo ""

  else
    PATH="$PATH:$THIS_DIR/../mksh_setup/bin"
    PATH="$PATH:$THIS_DIR/bin"
    if ! type crystal &>/dev/null; then
      echo "!!! Crystal not found in path." >&2
      exit 2
    fi
    mksh_setup watch "-r src -r spec -r $THIS_DIR/bin/public/watch" "$(basename "$THIS_DIR") watch run"
  fi

} # === end function

