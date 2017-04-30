
# === {{CMD}}  #  Create a binary in tmp/ for development or testing.
dev () {
  source "$THIS_DIR/dev/paths.sh"

  cd "$THIS_DIR"
  mkdir -p tmp
  cd tmp
  crystal build ../src/mu-html.cr
  echo "=== Wrote: tmp/mu-html"
} # === end function
