
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
  puts ("invalid json")
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

    json = case json
           when Hash
             Base.allowed_keys(SECTIONS, json)
             {
               "meta": Meta.parse(json),
               "data": Data.parse(json),
               "markup": Markup.parse(json),
               "style": Style.parse(json)
             }
           else
             raise Exception.new("A key/value data structure was not found.")
           end # === case json

  rescue JSON::ParseException
    nil
  end # === def parse

  def read_file(path : String)
    return nil if !path.valid_encoding?
    return nil if !File.file?(path)
    content = File.read(path)
    return nil if !content
    return if !content.valid_encoding?
    content
  rescue Exception
    nil
  end # === def read_file

end # === module Mu_Html

