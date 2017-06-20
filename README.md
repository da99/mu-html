# mu-html

HTML to a WWW-App... in Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  mu-html:
    github: [your-github-name]/mu-html
```

## Usage

```crystal
  require "mu-html"

  Mu_HTML.to_html do
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



Usage
=====

```crystal

  require "mu-clean"

  Mu_Clean.attrs("input", {"type"=>"hidden", "value"=>"my val"})
  Mu_Clean.attrs("meta", {"name"=>"keywords", "content"=>" <my content> "})
  Mu_Clean.escape("my <html>")
  Mu_Clean.uri("http://my.uri")

```

Void Linux
==========

Install libxml2-devel


Mu\_Clean.uri
================

I use this shard to sanitize uri/urls for `src` and `href` html attributes.

however, if you know of another uri/url sanitization shard to be used for
`src` and `href` attributes, please let me know in the "issues" section
so i can tell others about it.

you don't want to use this shard because it's too specific for my needs.
it's very strict and only allows `http`, `https`, `ftp`, `sftp`.
no `mailto` or other schemes. so it's basically useless for most people
unless they share my views on paranoid security.


specs for this shard was inspired by:
  * https://github.com/jarrett/sanitize-url/tree/master/spec
