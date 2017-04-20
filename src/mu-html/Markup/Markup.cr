
require "./macro"
require "./Base"
require "./Tag"
require "./*"

module Mu_Html

  module Markup

    TAGS = {
      "p": P,
      "div": DIV,
      "each": EACH
    }

    REGEX = {
      "id": /^[a-z0-9\_]+$/,
      "class": /^[a-z0-9\-\_\ ]+$/,
      "empty_string": /^$/,
      "data_id" : /^[a-z0-9\_\.\-]+$/,
      "non_empty_string": /^.+$/
    }

    VALID_HTML = {
      "span": {
        attrs: ID_AND_OR_CLASS,
        tags: {
          { "span"=> String },
          { "span"=> Hash,       "data"=> String },
          { "span"=> Empty_Hash, "data"=> String }
        }
      },

      "footer" : {
        attrs: ID_AND_OR_CLASS,
        tags: {
          { "footer"=> Hash,       "data"=> String },
          { "footer"=> Empty_Hash, "data"=> String },
          { "footer"=> String }
        }
      }
    } # === VALID_HTML

    def self.validate_tag(o : Hash(String, JSON::Type))
      {% for tag, mod in TAGS %}

        if o.has_key?({{tag.stringify}})
          return {{mod.id}}.validate_tag(o)
        end

      {% end %}

      raise Exception.new("Unknown tag with keys: #{o.keys}")
    end # === validate

    def self.parse(json)
      markup = json.has_key?("markup") ? json["markup"] : nil

      case markup

      when Nil
        [] of JSON::Type

      when Array(JSON::Type)
        markup.map { | raw |
          case raw
          when Hash(String, JSON::Type)
            validate_tag(raw)
          else
            raise Exception.new("Invalid value: #{raw}")
          end
        }

      else
        raise Exception.new("Markup can only be an Array of items.")

      end # === case
    end # === def parse

  end # === module Markup

end # === module Mu_Html
