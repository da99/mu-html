


require "json"

arr = [
  ["title", "title"] of JSON::Type,
  ["p", "my_name"] of JSON::Type
] of JSON::Type

module Mu_HTML
  extend self
  def to_html(o, data : Hash(String, JSON::Type))
    page = o.new(IO::Memory.new, data)
    page.html
    page.to_s
  end
end # === Mu_HTML

module To_Html

  macro included
    extend Extension
    @@data = {
    } of String => String
  end

  module Extension
    def to_html(data : Hash(String, JSON::Type))
      page = new(IO::Memory.new, data)
      page.html
      page.to_s
    end

    def load_data(dir : String)
      Dir.glob(dir).each do |file|
        name = File.basename(file, ".txt")
        @@data[name] = File.read(file).rstrip
      end
    end
  end # === module Extension

  def initialize(@io : IO::Memory, @data : Hash(String, JSON::Type))
  end

  def to_s
    @io
  end

  def with_data(d : Hash(String, JSON::Type))
    old_data = @data
    new_data = @data.merge(d)
    @data = new_data
    with self yield
    @data = old_data
  end

  def data(k : Symbol)
    name = k.to_s
    return @@data[name] if @@data.has_key?(name)
    return @data[name] if @data.has_key?(name)
    raise Exception.new("Data not found: #{k.inspect}")
  end # === def data

  def run
    with self yield
  end

  def head
    @io << "<!DOCTYPE html>"
    @io << "\n<html>\n  <head>"
    with self yield
    @io << "\n  </head>"
  end

  def title(k : Symbol)
    @io << "\n    <title>"
    paste k
    @io << "</title>"
  end

  def body
    @io << "\n  <body>"
    with self yield
    @io << "\n  </body>"
    @io << "\n</html>"
  end

  def p(k : Symbol)
    @io << "\n    <p>"
    paste(k)
    @io << "</p>"
  end

  def paste(k : Symbol)
    @io << data(k)
  end

  def partial(o)
    @io << o.to_html(@data)
  end # === def partial
end # === struct Meta

module Homepage
  struct Page

    include To_Html
    load_data("./tmp/*.txt")

    def html
      head do
        title :title
      end

      body do
        p :msg
        with_data({"msg"=>"temp msg"} of String => JSON::Type) do
          partial Partial
        end
        partial Partial
      end
    end # === def to_html

  end # === struct Page

  struct Fragment
    include To_Html

    load_data("./tmp/*.txt")
    def html
      p :msg
    end # === def to_html

  end # === module Fragment
end # === module Homepage

require "./_Partial.cr"

data = {
  "title"=>"The Title",
  "msg"=>"*msg 1"
} of String => JSON::Type

puts Homepage::Page.to_html( data )
puts Homepage::Fragment.to_html( data )






