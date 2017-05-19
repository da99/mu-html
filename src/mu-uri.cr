
require "uri"
require "html"

module Mu_URI

  VALID_FRAGMENT = /^[a-zA-Z0-9\_\-]+$/
  BEGINNING_SLASH = /^\//

  extend self

  def unescape(raw : String)
    old_s = ""
    new_s = raw
    while old_s != new_s
      old_s = new_s
      new_s = HTML.unescape(new_s)
    end
    new_s
  end # === def unescape

  def slash_for_relative_urls(u : URI)
    if !u.scheme && u.path && u.path !~ BEGINNING_SLASH
      return nil
    end
    u
  end # === def slash_for_relative_urls

  def is_fragment_only?(u : URI)
    u.fragment && !u.host && !u.query && !u.path
  end

  def clean_fragment(s : String)
    s = s.strip
    return nil unless s =~ VALID_FRAGMENT
    s
  end # === def clean_fragment

  def clean_fragment(n : Nil)
    nil
  end

  def clean_fragment(u : URI)
    u.fragment = clean_fragment(u.fragment)
    u
  end # === def clean_fragment

  def clean_scheme(n : Nil)
    nil
  end # === def clean_scheme

  def clean_scheme(s : String)
    case s
    when "http", "https", "ftp", "sftp"
      s
    else
      nil
    end
  end

  def clean_scheme(u : URI)
    scheme = u.scheme
    case scheme
    when String
      u.scheme= (clean_scheme(scheme) || clean_scheme(scheme.downcase.strip))
    else
      u.scheme = clean_scheme(scheme)
    end

    u
  end

  def normalize(n : Nil)
    nil
  end # === def normalize

  def normalize(u : URI)
    fin = u.normalize.to_s.strip
    return nil if fin == ""
    HTML.escape(fin)
  end # === def normalize

  def escape(raw : String)
    raw = unescape(raw.strip)
    u = URI.parse(raw)

    origin_scheme = u.scheme

    {% for meth in "scheme fragment".split  %}
      if u
        u = clean_{{meth.id}}(u)
        return u unless u
      end
    {% end %}

    # If the scheme disappeared, that means the entire
    # URL was invalid to begin with. Return nil to be
    # safe.
    return nil if origin_scheme && !u.scheme
    u = slash_for_relative_urls(u)
    normalize(u)
  end # === def escape

end # === module Mu_URI
