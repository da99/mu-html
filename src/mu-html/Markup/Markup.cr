
require "./macro"
require "./Base"
require "./Tag"
require "./*"

module Mu_Html

  class Markup


    def self.parse(json)
      markup = json.has_key?("markup") ? json["markup"] : nil

      case markup

      when Nil
        raise Exception.new("Invalid json.")

      else
        new(markup).tags
      end # === case
    end # === def parse

    TAGS = {
      "p": P,
      "div": DIV,
      "each": EACH,
      "footer": FOOTER,
      "input": INPUT
    }

    REGEX = {
      "id": /^[a-z0-9\_]+$/,
      "class": /^[a-z0-9\-\_\ ]+$/,
      "data_id" : /^[a-z0-9\_\.\-]+$/
    }

    getter origin : Array(JSON::Type)
    getter tags : Array(Tag)

    def initialize(@origin : Array(JSON::Type))
      @tags = origin.map { | raw |
        validate_tag(raw)
      }
    end # === def initialize

    def initialize(raw)
      @origin = [] of JSON::Type
      @tags = [] of Tag
      raise Exception.new("Markup can only be an Array of tags.")
    end # === def initialize

    def validate_tag(o : Hash(String, JSON::Type))
      {% for tag, mod in Markup::TAGS %}

        if o.has_key?({{tag.stringify}})
          return {{mod.id}}.validate_tag(o)
        end

      {% end %}

      raise Exception.new("Unknown tag with keys: #{o.keys}")
    end # === def validate_tag

    def validate_tag(raw)
      raise Exception.new("Invalid value: #{raw}")
    end # === def validate_tag

    def to_array
      tags.map(&.to_hash)
    end

  end # === class Markup

end # === module Mu_Html
