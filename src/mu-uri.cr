
require "uri"
require "html"

module Mu_URI

  VALID_FRAGMENT  = /^[a-zA-Z0-9\_\-]+$/
  BEGINNING_SLASH = /^\//
  CNTRL_CHARS     = /[[:cntrl:]]+/i
  WHITE_SPACE     = /[\s[:cntrl:]]+/i
  FIND_A_DOT      = /\./
  FIND_A_SLASH    = /\//
  PATH_HAS_A_HOST = /^[^\/]+\/?/

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

  def set_default_host(n : Nil)
    nil
  end # === def set_default_host

  def set_default_host(u : URI)
    if !u.scheme && !u.host && (u.path.is_a?(String) && u.path =~ FIND_A_DOT && u.path =~ PATH_HAS_A_HOST)
      u.scheme = "http"
    end
    u
  end # === def set_default_host

  def require_slash_for_relative_urls(u : URI)
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

  def is_allowed_scheme?(s : String)
    case s
    when "http", "https", "ftp", "sftp"
      return true
    end
    false
  end

  def clean_scheme(s : String)
    return s if is_allowed_scheme?(s)

    new_s = URI.unescape(s.downcase.strip)
    return new_s if is_allowed_scheme?(new_s)
    nil
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

  def is_empty?(n : Nil)
    true
  end # === def is_empty?

  def is_empty?(s : String)
    s.strip.empty?
  end # === def is_empty?

  def normalize(u : URI)
    fin = u.normalize.to_s.strip
    return nil if fin == ""
    return nil if is_empty?(u.host) && is_empty?(u.path) && is_empty?(u.fragment)
    HTML.escape(fin)
  end # === def normalize

  def clean_cntrl_chars(s : String)
    return nil if s =~ CNTRL_CHARS
    s
  end # === def clean_cntrl_chars

  def clean_host(s : String)
    return nil if s =~ WHITE_SPACE
    return nil if s.empty?
    s
  end # === def clean_host

  def clean_host(u : URI)
    s = u.host
    case s
    when String
      new_host = clean_host(s)
      return nil unless new_host
      u.host = new_host
    end
    return u
  end # === def clean_host

  def escape(raw : String)
    raw = unescape(raw.strip)
    raw = clean_cntrl_chars(raw)
    return nil unless raw

    u = URI.parse(raw)

    origin_scheme = u.scheme

    {% for meth in "scheme fragment host".split  %}
      if u
        u = clean_{{meth.id}}(u)
        return u unless u
      end
    {% end %}

    # If the scheme disappeared, that means the entire
    # URL was invalid to begin with. Return nil to be
    # safe.
    return nil if origin_scheme && !u.scheme
    u = set_default_host(u)
    u = require_slash_for_relative_urls(u)
    normalize(u)
  end # === def escape

end # === module Mu_URI
