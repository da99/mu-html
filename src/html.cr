
require "json"
require "html"
require "./tidy"

module Mu_WWW_HTML

  extend self

  def render
    markup = DSL.new
    with markup yield
    markup.io.rewind.to_s
  end # === def to_html

  #
  # Exists with a non-zero status code
  # if HTML5 input is invalid.
  #
  def tidy!(*args)
    tidy(*args)
  end # === def tidy

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


  # =========================================================================
  # === DSL =================================================================
  # =========================================================================

  class DSL

    getter io

    def initialize(
      @io : IO::Memory = IO::Memory.new,
      @data : Hash(String, JSON::Type) = {} of String => JSON::Type
    )
    end

    # =========================================================================
    # === TAGS ================================================================
    # =========================================================================

    def html
      @io << "<!DOCTYPE html>"
      @io << "\n<html>"
      with self yield
      @io << "\n</html>"
    end

    def head
      io << "\n  "
      write_tag("head") do
        meta({"charset"=>"utf-8"})
        yield
      @io << "\n"
      end
    end # === def head

    def body(*args)
      io << "\n  "
      write_tag("body", *args) do
        yield
      end
    end # === def body

    def title(txt = String)
      @io << "\n"
      write_tag("title", txt)
    end # === def title

    def span(txt : String)
      write_tag("span", txt)
    end # === def span

    def meta(attrs : Hash(String, String))
      @io << "\n"
      write_tag("meta", attrs)
    end # === def meta

    def p(*args)
      write_tag("p", *args)
    end # === def p

    def each(*args)
      write_tag("each") do
        yield
      end
    end # === def each

    def footer(txt : String)
      write_tag("footer", txt)
    end # === def footer

    def input(attrs)
      write_tag_closed("input", attrs)
    end # === def input

    def div(*args)
      write_tag("div", *args) do
        yield
      end
    end # === def div

    def if?(*args)
      write_tag("if?") do
        yield
      end
    end # === def if?

    def equal?(*args)
      write_tag("equal?") do
        yield
      end
    end # === def equal?

    # =========================================================================
    # === WRITE ===============================================================
    # =========================================================================

    def write_tag(name : String, content : String)
      @io << "<#{name}>"
      write_tag_body(content)
      @io << "</#{name}>"
    end # === def write_tag

    def write_attrs(tag, raw_attrs)
      attrs = Mu_WWW_Attr.clean(tag, raw_attrs)
      if !attrs
        raise Exception.new("Invalid attributes: #{tag.inspect} #{raw_attrs.inspect}")
      end
      return unless attrs
      attrs.each { |k, v|
        @io << " #{k}=#{v.inspect}"
      }
      true
    end # === def write_attrs

    def write_tag(name : String, attrs : Hash(String, String))
      @io << "<#{name}"
      write_attrs(name, attrs)
      @io << ">"
    end # === def write_tag

    def write_tag(name : String, attrs : Hash(String, String))
      @io << "<#{name}"
      write_attrs(name, attrs)
      @io << ">"
      yield
      @io << "</#{name}>"
    end # === def write_tag

    def write_tag(name : String)
      @io << "<#{name}>"
      yield
      @io << "</#{name}>"
    end # === def write_tag

    def write_tag_closed(name : String, attrs : Hash)
      @io << "<"
      @io << name
      write_attrs("input", attrs)
      @io << ">"
    end # === def write_tag_closed

    def write_tag_body(content : String)
      @io << Mu_WWW_HTML.escape(content)
    end # === def write_tag_body

  end # === class DSL

end # === module Mu_WWW_HTML

