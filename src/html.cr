
require "json"
require "html"
require "./tidy"

module Mu_WWW_HTML

  module Main

    def render
      markup = new
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

  end # === module Main

  # =========================================================================
  # === DSL =================================================================
  # =========================================================================

  module DSL

    getter io

    def initialize(
      @io : IO::Memory = IO::Memory.new,
      @data : Hash(String, JSON::Type) = {} of String => JSON::Type
    )
    end

    # =========================================================================
    # === TAGS ================================================================
    # =========================================================================

    def doctype
      @io << "<!DOCTYPE html>"
    end # === def doctype

    def html
      doctype
      @io << "\n<html>"
      with self yield
      @io << "\n</html>"
    end

    def head
      io << "\n  "
      tag("head") do
        meta({"charset"=>"utf-8"})
        yield
      @io << "\n"
      end
    end # === def head

    def body(*args)
      io << "\n  "
      tag("body", *args) do
        yield
      end
    end # === def body

    def title(txt = String)
      @io << "\n"
      tag("title", txt)
    end # === def title

    def meta(attrs : Hash(String, String))
      @io << "\n"
      tag("meta", attrs)
    end # === def meta

    # =========================================================================
    # === WRITE ===============================================================
    # =========================================================================

    private def tag(name : String, content : String)
      @io << "<#{name}>"
      tag_body(content)
      @io << "</#{name}>"
    end # === def tag

    private def tag_attrs(tag, raw_attrs : Hash)
      new_attrs = raw_attrs.keys.reduce(raw_attrs) do |attrs, k|
        break nil unless Mu_WWW_Attr.valid_key?(k)

        case attrs
        when Hash
          temp = tag_attr(tag, k, attrs[k], attrs)
          break nil unless temp.is_a?(Hash)
          temp
        else
          break nil
        end
      end

      if !new_attrs
        raise Exception.new("Invalid attributes: #{tag.inspect} #{raw_attrs.inspect}")
      end

      new_attrs.keys.each do |k|
        new_attrs[k] = Mu_WWW_HTML.escape(new_attrs[k])
      end

      new_attrs
    end # === def tag_attrs

    private def tag_attr(tag, name, val, attrs)
      Mu_WWW_Attr.tag_attr(tag, name, val, attrs)
    end # === def tag_attr

    private def tag(name : String, attrs : Hash(String, String))
      @io << "<"
      @io << name
      clean_then_write_attrs(name, attrs)
      @io << ">"
    end # === def tag

    private def tag(name : String, attrs : Hash(String, String))
      @io << "<#{name}"
      clean_then_write_attrs(name, attrs)
      @io << ">"
      yield
      @io << "</#{name}>"
    end # === def tag

    private def tag(name : String)
      @io << "<#{name}>"
      yield
      @io << "</#{name}>"
    end # === def tag

    private def tag(name : String, txt : String)
      @io << "<#{name}>"
      tag_body(txt)
      @io << "</#{name}>"
    end # === def tag

    private def tag_body(content : String)
      @io << Mu_WWW_HTML.escape(content)
    end # === def tag_body

    private def clean_then_write_attrs(tag, raw_attrs)
      tag_attrs(tag, raw_attrs).each { |k, v|
        @io << " #{k}=#{v.inspect}"
      }
      true
    end # === def clean_then_write_attrs

  end # === module DSL

  # =========================================================================
  macro included
    include DSL
    extend Main
  end # === macro included

  extend Main

  class Instance
    include Mu_WWW_HTML
  end # === class Instance

  def self.render
    markup = Instance
    with markup yield
    markup.io.rewind.to_s
  end # === def self.render
  # =========================================================================

end # === module Mu_WWW_HTML

