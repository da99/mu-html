
require "json"
require "html"
require "uri"

module Mu_Clean

  extend self

  VALID_KEY = /^[a-zA-Z0-9\_\-]{1,20}$/
  DATA_ID_INVALID = /[^a-zA-Z0-9\_\-]+/

  def data(json : Hash(String, JSON::Type))
    data = json["data"]?

      case data

    when Hash(String, JSON::Type)
      data.each do |k, v|
        data[key(k)] = value(v)
      end

    when Nil
      json["data"] = {} of String => JSON::Type

    else
      raise Exception.new("section data can only be a key => value structure")

    end
  end # === def parse

  def key(s : String)
    unless s =~ VALID_KEY 
      raise Exception.new("Invalid key in data section: #{s.inspect}")
    end
    s
  end # === def key

  def value(s : String)
    HTML.escape(s)
  end # === def value

  def value(i : Int32 | Int64)
    i
  end

  def value(arr : Array(JSON::Type))
    arr.each_index { |i|
      arr[i] = value(arr[i])
    }
    arr
  end

  def value(h : Hash(String, JSON::Type))
    h.each do |k, v|
      clean_k = key(k)
      raise Exception.new("Invalid key in data: #{k.inspect}") if clean_k != k
      clean_v = value(v)
      case clean_v
      when JSON::Type
        h[clean_k] = clean_v
      else
        raise Exception.new("Invalid value for #{k}: #{v.inspect}")
      end
    end
    h
  end # === def value

  def value(u : Bool)
    u
  end

  def value(u)
    raise Exception.new("Invalid value for data: #{u.inspect}")
    u
  end

  def get(data : Hash(String, JSON::Type))
    v = data["data"]?
      case v
    when Hash(String, JSON::Type)
      :ignore
    else
      raise Exception.new("Data section not found. Keys: #{data.keys}")
    end

    v
  end # === def get

  def get(data : Hash(String, JSON::Type), key : String )
    if key =~ DATA_ID_INVALID
      raise Exception.new("Invalid data key: #{key}")
    end
    keys = key.strip.split(".")
    get(get(data), 0, keys)
  end # === def get

  def get(data : Hash(String, JSON::Type), i : Int32, keys : Array(String))
    if i >= keys.size || !data.has_key?(keys[i])
      raise Exception.new("Data not found: #{keys.join(".")}")
    end
    get(data[keys[i]], i+1, keys)
  end # === def get

  def get(data : String | Int64, i : Int32, keys : Array(String))
    HTML.escape(data.to_s)
  end # === def get

  def get(u1, u2, keys : Array(String))
    raise Exception.new("Invalid data value: #{keys.join(".")}")
  end # === def get

  def get(data : JSON::Type, key : JSON::Type)
    case data
    when Hash(String, JSON::Type)
      case key
      when String
        return data[key] if data.has_key?(key)
      end
    end

    raise Exception.new("Data not found: #{key.inspect} in #{data.inspect}")
  end # === def get

  def get_each(data, key)
    v = get(data, key)
    case v
    when Array, Hash
      return v
    end
    raise Exception.new("Invalid data: #{key.inspect} in #{data.inspect}")
  end # === def get_each

  def new_key(data : Hash(String, JSON::Type), key : String, v : String | Int32 | Int64)
    raise Exception.new("Data already exists: #{key.inspect}") if data.has_key?(key)
    data[key] = v
  end # === def new_key

  def new_key(data, key, v)
    raise Exception.new("Invalid retrieval of data: #{data.inspect}, #{key.inspect}, #{v.inspect}")
  end

  def delete(data : Hash(String, JSON::Type), key : String)
    data.delete(key)
  end # === def delete

  def delete(data, key)
    raise Exception.new("Can't delete data: #{data.inspect}, #{key.inspect}")
  end # === def delete

  # =========================================================================
  # === .escape =============================================================
  # =========================================================================

  def escape(s : String) : String
    new_s = unescape(s)
    HTML.escape(new_s)
  end # === def escape

  def escape(i : Int32 | Int64)
    i
  end # === def escape

  def escape(a : Array)
    a.map { |v| escape(v) }
  end # === def escape

  def escape(h : Hash(String, JSON::Type))
    h.each do |k, v|
      h[k] = escape(v)
    end
    h
  end # === def escape

  def escape(u)
    raise Exception.new("Invalid value ")
    escape(u.to_s)
  end # === def escape

  def unescape(s : String)
    old_s = ""
    new_s = s
    while old_s != new_s
      old_s = new_s
      new_s = HTML.unescape(new_s)
    end
    new_s
  end

  def unescape(u)
    unescape(u.to_s)
  end

  def attr_name(tag_name : String, attrs : Hash)
    case tag_name
    when "input"
      val = attrs["name"]?
        return nil unless val
      invalid_attr(tag_name, "name", val) unless val =~ /^[a-zA-Z0-9\_\-]+$/
      { "name", val }
    else
      invalid_attr(tag_name, "name")
    end
  end # === def attr_name

  def attr_type(tag_name : String, attrs : Hash)
    val = attrs["type"]?
      case
    when tag_name == "input" && val == "hidden"
      return { "type", "hidden" }
    end # === case tag_name
    invalid_attr(tag_name, "type", val)
  end # === def attr_type

  def attr_value(tag_name : String, attrs : Hash)
    val = attrs["value"]?

      case
    when val.is_a?(String) && val =~ /^[a-zA-Z0-9\_\ \-\.]+$/
      return { "value", val }
    end

    invalid_attr(tag_name, "value", val)
  end # === def attr_value

  def attr_class(tag_name : String, attrs : Hash)
    val = attrs["class"]?
      case
    when val.is_a?(String) && val =~ /^[a-zA-Z0-9\_\ ]+$/
      return { "class", val }
    end
    invalid_attr(tag_name, "class", val)
  end # === def attr_class

  # ===========================================================================
  # === URI ===================================================================
  # ===========================================================================

  VALID_FRAGMENT  = /^[a-zA-Z0-9\_\-]+$/
  BEGINNING_SLASH = /^\//
  CNTRL_CHARS     = /[[:cntrl:]]+/i
  WHITE_SPACE     = /[\s[:cntrl:]]+/i
  FIND_A_DOT      = /\./
  FIND_A_SLASH    = /\//
  PATH_HAS_A_HOST = /^[^\/]+\/?/

  def require_slash_for_relative_urls(u : URI)
    if !u.scheme && empty?(u.host) && (u.path.is_a?(String) && u.path !~ BEGINNING_SLASH)
      return nil
    end
    u
  end # === def slash_for_relative_urls

  def scheme(n : Nil)
    nil
  end # === def scheme

  def scheme(s : String)
    s = URI.unescape(s)
    return s if allowed_scheme?(s)

    new_s = URI.unescape(s.downcase.strip)
    return new_s if allowed_scheme?(new_s)
    nil
  end

  def scheme(u : URI)
    sch = u.scheme
    case sch
    when String
      u.scheme = (scheme(sch) || scheme(sch.downcase.strip))
    else
      u.scheme = scheme(sch)
    end

    u
  end

  def normalize(n : Nil)
    nil
  end # === def normalize

  def normalize(u : URI)
    fin = u.normalize.to_s.strip
    return nil if fin == ""
    return nil if empty?(u.host) && empty?(u.path) && empty?(u.fragment)
    HTML.escape(escape_non_ascii(fin))
  end # === def normalize

  def cntrl_chars(s : String)
    return nil if s =~ CNTRL_CHARS
    s
  end # === def cntrl_chars

  def escape_non_ascii(s : String)
    s.gsub( /[^[:ascii:]]+/ ) do | str |
      URI.escape(str)
    end
  end # === def escape_non_ascii

  def host(s : String)
    return nil if s =~ WHITE_SPACE
    return nil if s.empty?

    decoded = URI.unescape(s)
    return nil if decoded != s

    escape_non_ascii(s)
  end # === def host

  def host(u : URI)
    s = u.host
    case s
    when String
      new_host = host(s)
      return nil unless new_host
      u.host = new_host
    end
    return u
  end # === def host

  def uri(raw : String)
    raw = unescape(raw.strip)
    raw = cntrl_chars(raw)
    return nil unless raw

    u = URI.parse(raw)

    origin_scheme = u.scheme

    u = default_host(u)
    {% for meth in "scheme uri_user uri_password uri_opaque uri_fragment host path".split  %}
      if u
        u = {{meth.id}}(u)
        return nil unless u
      end
    {% end %}

    # If the scheme disappeared, that means the entire
    # URL was invalid to begin with. Return nil to be
    # safe.
    return nil if origin_scheme && !u.scheme
    u = default_scheme(u)
    u = require_slash_for_relative_urls(u)
    normalize(u)
  end # === def escape

  # ===========================================================================
  # private # ===================================================================
  # ===========================================================================

  def inspect_uri(n : Nil)
    puts n.inspect
  end

  def inspect_uri(s : String)
    inspect_uri(URI.parse(s))
  end # === def inspect_uri

  def inspect_uri(uri : URI)
    puts uri.to_s
    {% for id in ["scheme", "uri_opaque", "uri_user", "uri_password", "host", "path", "query", "uri_fragment"] %}
      spaces = " " * (15 - "{{id.id}}".size)
      puts "{{id.id}}:#{spaces}#{uri.{{id.id}}.inspect}"
    {% end %}
    puts uri.normalize.to_s
    puts ""
  end # === def inspect_uri

  def path(s : String)
    return nil if empty?(s)
    new_s = s.strip
    decoded = URI.unescape(new_s)
    return nil if decoded != new_s
    new_s
  end # === def path

  def path(n : Nil)
    nil
  end # === def path

  def path(u : URI)
    new_p = path(u.path)
    u.path = new_p
    u
  end # === def path

  def uri_user(u : URI)
    u.user = nil
    u
  end # === def uri_user

  def uri_password(u : URI)
    u.password = nil
    u
  end # === def uri_password

  # If .opaque is not nil, then that
  # means we are dealing with a missing double slash:
  # mailto:something
  # git:something
  # http:something
  # These are all invalid, including a valid mailto.
  # Those types of URIs should be handle by other shards/gems
  # for better error checking and security.
  def uri_opaque(u : URI)
    o = u.opaque
    return nil unless empty?(o)
    u
  end # === def uri_opaque

  def is_fragment_only?(u : URI)
    u.fragment && !u.host && !u.query && !u.path
  end

  def uri_fragment(s : String)
    s = s.strip
    return nil unless s =~ VALID_FRAGMENT
    s
  end # === def uri_fragment

  def uri_fragment(n : Nil)
    nil
  end

  def uri_fragment(u : URI)
    u.fragment = uri_fragment(u.fragment)
    u
  end # === def uri_fragment

  def allowed_scheme?(s : String)
    case s
    when "http", "https", "ftp", "sftp", "git", "ssh", "svn"
      return true
    end
    false
  end

  def default_host(u : URI)
    return u unless empty?(u.host)
    return u if empty?(u.path)
    path = u.path
    case path
    when String
      crumbs = path.split("/")
      return u if crumbs.empty?
      return u if empty?(crumbs.first) # /some/path
      new_host = crumbs.first
      crumbs[0] = ""
      u.host = new_host
      u.path = crumbs.join("/")
      u.path = nil if empty?(u.path)
    end
    u
  end # === def default_host

  def default_scheme(n : Nil)
    nil
  end # === def default_scheme

  def default_scheme(u : URI)
    if !u.scheme
      if !empty?(u.host)
        u.scheme = "http"
      end
    end
    u
  end # === def default_scheme

  def empty?(n : Nil)
    true
  end # === def empty?

  def empty?(s : String)
    s.strip.empty?
  end # === def empty?

end # === module Mu_Clean

