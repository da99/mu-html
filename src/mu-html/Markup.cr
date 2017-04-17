
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

      "each": {
        attrs: ID_AND_OR_CLASS,
        tags: {
          {"each"=> String, "as"=> String, "loop"=> Array}
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

    def self.standardize(o : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
      {% for mod in Markup.constants.select { |x|
        y = Markup.constant(x)
        y.is_a?(TypeNode) && y.methods.map(&.name.id).includes?(:validate.id)
      } %}
        if o.has_key?("{{mod.downcase}}")
          return {{mod}}.validate(o)
        end
      {% end %}

      raise Exception.new("Unknown tag: #{o.keys}")
    end

    def self.parse(json)
      markup = json.has_key?("markup") ? json["markup"] : nil
      case markup
      when Nil
        [] of JSON::Type
      when Array
        markup.map do | raw |
          case raw
          when Hash(String, JSON::Type)
            standardize(raw)
          else
            raise Exception.new("Invalid tag: #{raw} (#{raw.class}")
          end
        end
      else
        raise Exception.new("Markup can only be an Array of items.")
      end
    end

  end # === module Markup

end # === module Mu_Html
