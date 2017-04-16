
require "./mu-html/*"
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
else
  puts json
end
# ==========================================

module Mu_Html

  extend self

  VALID_SECTIONS = {"meta", "data", "markup", "style"}
  VALID_META_KEYS = {"title", "layout"}

  def parse(path : String)
    source = read_file(path)
    return nil if !source || !source.valid_encoding?

    json = JSON.parse_raw(source)

    json = case json
           when Hash
             validate_sections(json)
           end

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

  def make_nil_if_empty_string(raw : String)
    str = raw.strip
    str.empty? ? nil : str
  end

  def make_nil_if_empty_string(raw)
    raw
  end

  def validate_sections(json : Hash)
    json = validate_keys("json sections", VALID_SECTIONS, json)

    {
      "meta": parse_meta(json),
      "data": parse_data(json),
      "markup": Markup.parse(json),
      "style": Style.parse(json)
    }
  end # === def validate_sections

  def parse_meta(json : Hash)
    return({} of String => JSON::Type) unless json.has_key?("meta")

    meta = json["meta"]
    case meta
    when Hash(String, JSON::Type)

      meta       = validate_keys("meta", VALID_META_KEYS, meta)
      valid_meta = {} of String => String | Int32 | Int64

      meta.each do |key, value|
        case key
        when String
          raise Exception.new("invalid meta key: #{key}") if !VALID_META_KEYS.includes?(key)

          case value
          when String, Int64
            valid_meta[key] = value
          else
            raise Exception.new("invalid value for meta[#{key}]")
          end

        else
          raise Exception.new("invalid meta key: not a string")
        end
      end
    else
      raise Exception.new("invalid meta")
    end

    valid_meta
  end

  def parse_data(json : Hash(String, JSON::Type) )
    data = json.has_key?("data") ? json["data"] : nil
    case json["data"]
    when Hash
      json["data"]
    when Nil
      {} of String => JSON::Type
    else
      raise Exception.new("section data can only be a key => value structure")
    end
  end

end # === module Mu_Html

