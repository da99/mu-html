
# === {{CMD}}
run-specs () {
  cd "$THIS_DIR"

  echo "=== Compiling..."
  crystal build specs/mu-uri.spec.cr
  mv mu-uri.spec tmp/

  local +x IFS=$'\n'
  for DIR in $(find specs -maxdepth 1 -mindepth 1 -type d | sort) ; do
    tmp/mu-uri.spec "$DIR" | sh_color GREEN
  done
} # === end function
