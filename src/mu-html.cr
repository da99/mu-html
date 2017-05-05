
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
    "meta",
    "data",
    "markup",
    "style"
  }

  def self.clean(h : JSON::Type)
    unescape every string
    run each string through crystal-mustache
    escape { and }
  end # === def self.clean

  def parse(path : String)
    source = read_file(path)
    raise Exception.new("Empty file.") unless source
    raise Exception.new("Invalid text encoding.") unless source.valid_encoding?

    json = JSON.parse_raw(source)

    case json
    when Hash
      Base.allowed_keys(SECTIONS, json)
      Meta.clean(json)
      Data.clean(json)
      Markup.clean(json)
      Style.clean(json)
    else
      raise Exception.new("A key/value data structure was not found.")
    end # === case json

    json
  end # === def parse

  def read_file(path : String)
    return nil if !path.valid_encoding?
    return nil if !File.file?(path)
    content = File.read(path)
    return nil if !content
    return if !content.valid_encoding?
    content
  end # === def read_file

end # === module Mu_Html

