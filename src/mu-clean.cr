
require "json"
require "html"
require "uri"
require "./uri"
require "./attr"
require "./data"

module Mu_Clean

  extend self

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

  def uri(*args)
    Uri.clean(*args)
  end # === def uri

  def attr(tag_name, name, val)
    {% for meth in Attr.methods.select { |meth| meth.visibility == :public } %}
      if name == {{meth.name.stringify}}
        return Attr.{{meth.name.id}}(tag_name, val)
      end
    {% end %}

    Attr.invalid(tag_name, name, val)
  end # === def attr

  def empty?(n : Nil)
    true
  end # === def empty?

  def empty?(s : String)
    s.strip.empty?
  end # === def empty?

end # === module Mu_Clean

