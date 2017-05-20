
# === {{CMD}}
watch-specs () {
  cd "$THIS_DIR"
  PATH="$PATH:../mksh_setup/bin"
  local +x CMD="mu-uri run-specs"
  $CMD || :
  mksh_setup watch "-r bin -r src -r specs" "$CMD"
} # === end function
