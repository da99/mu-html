
require "./mu-html/Base/Base"
require "./mu-html/Data/Data"
require "./mu-html/Markup/Markup"
require "./mu-html/Meta/Meta"
require "./mu-html/Style/Style"

require "option_parser"
require "json"

file = "none"

OptionParser.parse! do |parser|
  parser.banner = "Usage: mu-html [arguments]"
  parser.on("--file FILE", "File to process.") { |f| file = f }
end # === OptionParser

# ====== Scratchpad =======================
json = Mu_Html.parse(file)
case json
when nil
  puts ("Parse error: invalid json")
  Process.exit(2)
else
  puts json
end
# ==========================================

module Mu_Html

  extend self

  SECTIONS = {
    "meta",
    "data",
    "markup",
    "style"
  }

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

