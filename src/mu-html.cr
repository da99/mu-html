
require "json"
require "./mu-html/Base/Base"
require "./mu-html/Escape/Escape"
# require "./mu-html/Markup/Markup"

module Mu_Html

  extend self

  # === Methods to parse data: =====================
  def parse(path : String)
    source = if File.file?(path)
               content = File.read(path)
               raise Exception.new("Empty file.") unless content
               raise Exception.new("Invalid content encoding.") unless content.valid_encoding?
               content
             else
               path
             end

    parse(JSON.parse_raw source)
  end # === def parse

  def parse(json : Hash(String, JSON::Type))
    json.each_key { |k|
      raise Exception.new("Unknown key: #{k}") unless SECTIONS.includes?(k)
    }

    Escape.escape(json)
    Markup.clean(json)

    content = {} of Symbol => String
    Markup.to_s(json, content)

    content
  end # === def parse

  def parse(u)
    raise Exception.new("Invalid json: JSON must be an Object with keys and values..")
  end

  # === DSL: ========================================

  def to_html
    markup = Markup.new
    with markup yield
    markup.io.rewind.to_s
  end # === def to_html

  class Markup

    getter io
    def initialize(
      @io : IO::Memory = IO::Memory.new,
      @data : Hash(String, JSON::Type) = {} of String => JSON::Type
    )
    end

    def html
      @io << "<!DOCTYPE html>"
      @io << "\n<html>"
      with self yield
      @io << "\n</html>"
    end

    def head
      io << "\n  "
      write_tag("head") do
        yield
      end
    end # === def head

    def body(*args)
      io << "\n  "
      write_tag("body", *args) do
        yield
      end
    end # === def body

    def title(txt = String)
      write_tag("title", txt)
    end # === def title

    def span(txt : String)
      write_tag("span", txt)
    end # === def span

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

    def input(*args)
      write_tag_closed("input")
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

    def write_tag(name : String, content : String)
      @io << "<#{name}>"
      write_tag_body(content)
      @io << "</#{name}>"
    end # === def write_tag

    def write_tag(name : String, args = nil)
      @io << "<#{name}>"
      yield
      @io << "</#{name}>"
    end # === def write_tag

    def write_tag_closed(name : String, *args)
      @io << "<#{name} args >"
    end # === def write_tag_closed

    def write_tag_body(content : String)
      @io << Escape.escape(content)
    end # === def write_tag_body

  end # === class Markup

end # === module Mu_Html

