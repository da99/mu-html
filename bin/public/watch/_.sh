
# === {{CMD}}
watch () {
  source "$THIS_DIR/dev/paths.sh"

  if [[ ! -z "$@" ]]; then
    echo "=== Compiling... $(date "+%H:%M:%S") ..." >&2
    bin/mu-html spec compile
    sleep 0.5
    OUTPUT_DIR="$THIS_DIR/tmp/spec/output"
    mkdir -p "$OUTPUT_DIR"
    "$(bin/mu-html spec bin-path)" --output "$OUTPUT_DIR" --file spec/00-it-works/input/input.json
    echo "============================================="
    echo ""

  else
    PATH="$PATH:$THIS_DIR/../mksh_setup/bin"
    PATH="$PATH:$THIS_DIR/bin"
    if ! type crystal &>/dev/null; then
      echo "!!! Crystal not found in path." >&2
      exit 2
    fi
    "$(basename "$THIS_DIR")" watch run || :
    mksh_setup watch "-r src -r spec -r bin" "$(basename "$THIS_DIR") watch run"
  fi

} # === end function

