
require "./Markup/Base"
require "./Markup/*"

module Mu_Html

  module Markup

    REGEX = {
      "id": /^[a-z0-9\_]+$/,
      "class": /^[a-z0-9\-\_\ ]+$/,
      "empty_string": /^$/
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

    def self.validate(o : Hash(String, JSON::Type))
      {% for mod in Markup.constants.select { |x| Markup.constant(x).is_a?(TypeNode) } %}
        {% if !Markup.constant(mod).methods.select { |x| x.name[0..8] == "tag_attr_" }.empty? %}
          if o.has_key?("{{mod.downcase}}")
            {% for meth in Markup.constant(mod).methods.map {|m| m.name }.select { |m| m[0..8] == "tag_attr_" } %}
              o = {{mod}}.{{meth}}(o)
            {% end %}
            return o
          end
        {% end %}
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
            validate(raw)
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
