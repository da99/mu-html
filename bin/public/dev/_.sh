
# === {{CMD}}  #  Create a binary in tmp/ for development or testing.
dev () {
  cd "$THIS_DIR"
  crystal build src/mu-html.cr
  mv mu-html tmp/
  echo "=== Wrote: tmp/mu-html"
} # === end function
