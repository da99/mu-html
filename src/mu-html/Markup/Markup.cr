
require "./macro"
require "./Base"
require "./Tag"

# === Include the tags: =======
require "./P"
require "./DIV"
require "./EACH"
require "./FOOTER"
require "./INPUT"
require "./SPAN"
# =============================

module Mu_Html

  class Markup

    REGEX = {
      "id": /^[a-z0-9\_]+$/,
      "class": /^[a-z0-9\-\_\ ]+$/,
      "data_id" : /^[a-z0-9\_\.\-]+$/
    }

    getter origin : Array(JSON::Type)
    getter tags   : Array(Tag)
    getter parent : Tag | Nil

    def initialize(json)
      initialize(nil, json)
    end

    def initialize(@parent : Tag | Nil, json)
      @tags = [] of Tag
      @origin = [] of JSON::Type
      markup = json.has_key?("markup") ? json["markup"] : nil

      case markup

      when Nil
        raise Exception.new("Invalid json.")

      when Array(JSON::Type)
        @origin = markup
        @tags = origin.map { | raw |
          Tag.new(self, raw)
        }

      else
        raise Exception.new("Markup can only be an Array of tags.")

      end # === case

    end # === def initialize

    def to_array
      tags.map(&.to_hash)
    end

  end # === class Markup

end # === module Mu_Html
