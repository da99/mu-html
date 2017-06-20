
module Mu_HTML

  # =========================================================================
  # === DATA/JSON ===========================================================
  # =========================================================================

  class Data

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
      DSL.clean(json)

      content = {} of Symbol => String
      DSL.to_s(json, content)

      content
    end # === def parse

    def parse(u)
      raise Exception.new("Invalid json: JSON must be an Object with keys and values..")
    end

  end # === class Data

end # === module Mu_HTML
