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

  Mu_Html.to_html do
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

