
require "json"
require "./mu-html/Base/Base"
require "./mu-html/Data/Data"
require "./mu-html/Markup/Markup"
require "./mu-html/Meta/Meta"
require "./mu-html/Style/Style"
require "./mu-html/Script/Script"

module Mu_Html

  extend self

  SECTIONS = {
    "data",
    "markup",
    "style"
  }

  def read_file(path : String)
    content = File.read(path)
    raise Exception.new("Empty file.") unless content
    raise Exception.new("Invalid content encoding.") unless content.valid_encoding?
    content
  end # === def read_file

  def parse(path : String)
    source = if File.file?(path)
               read_file(path)
             else
               path
             end

    parse(JSON.parse_raw source)
  end # === def parse

  def parse(json : Hash(String, JSON::Type))
    json.each_key { |k|
      raise Exception.new("Unknown key: #{k}") unless SECTIONS.includes?(k)
    }

    Data.clean(json)
    Markup.clean(json)
    Style.clean(json)
    Script.clean(json)

    content = {} of Symbol => String
    Markup.to_s(json, content)
    Style.to_s(json, content)
    Script.to_s(json, content)

    content
  end # === def parse

  def parse(u)
    raise Exception.new("Invalid json: JSON must be an Object with keys and values..")
  end

end # === module Mu_Html

