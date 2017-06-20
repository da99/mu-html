mu-www
==========

Utilities to generate and clean WWW-releated content.
Written as a Crystal shard.

Usage
=============

```crystal
  require "mu-www"

  Mu_WWW_Attr.clean("input", {"type"=>"hidden", "value"=>"my val"})
  Mu_WWW_Attr.clean("meta", {"name"=>"keywords", "content"=>" <my content> "})
  Mu_WWW_HTML.escape("my <html>")
  Mu_WWW_URI.clean("http://my.uri")

  Mu_WWW_HTML.render do
    html {
      head {
        title "My Title"
      }
      body {
        p "My text."
      }
    }
  end

```

Linux
==========

Install libxml2-dev
Install libxml2-devel (for Void Linux)


Mu\_WWW\_URI.clean
==================

I use this shard to sanitize uri/urls for `src` and `href` html attributes.

However, if you know of another uri/url sanitization shard to be used for
`src` and `href` attributes, please let me know in the "issues" section
so i can tell others about it.

you don't want to use this shard because it's too specific for my needs.
it's very strict and only allows `http`, `https`, `ftp`, `sftp`.
no `mailto` or other schemes. so it's basically useless for most people
unless they share my views on paranoid security.


specs for this shard was inspired by:
  * https://github.com/jarrett/sanitize-url/tree/master/spec
