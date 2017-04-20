
# === {{CMD}}  #  Create a binary in tmp/ for development or testing.
dev () {
  cd "$THIS_DIR"
  mkdir -p tmp
  cd tmp
  crystal build ../src/mu-html.cr || exit 2
  # mv mu-html tmp/
  echo "=== Wrote: tmp/mu-html"
} # === end function
