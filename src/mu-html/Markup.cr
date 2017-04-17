
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

    module Base
      extend self

      def tag_attr_tag(tag : String, o : Hash, k : String, v) : Hash(String, JSON::Type)
        raise Exception.new("Invalid attribute in #{tag}: tag") if o.has_key?("tag")
        o = case v
            when String
              raise Exception.new("#{tag} has body set twice.") if o.has_key?("body")
              o.delete(k)
              o["body"] = v.strip
              o
            when Nil
              o.delete(k)
              o
            else
              raise Exception.new("Invalid value: #{k}: #{v}")
            end
        o["tag"] = tag
        o
      end

      def tag_attr_body(tag : String, o : Hash, k : String, v) : Hash(String, JSON::Type)
        tag_value = o[tag]?
          body      = o["body"]?

          case
        when tag_value.is_a?(String) && body.is_a?(String)
          raise Exception.new("Body set twice: #{tag}: [string], body: [string]")
        when tag_value.is_a?(String) && body.is_a?(Nil)
          o[k] = tag_value.strip
        when !tag_value.is_a?(String) && body.is_a?(String)
          o["body"] = body.strip
        when tag_value.is_a?(Nil) && body.is_a?(String)
          o["body"] = body.strip
        else
          :ignore
        end

        o
      end

      def tag_attr_class(tag : String, o : Hash, k : String, v) : Hash(String, JSON::Type)
        case v
        when String
          v = v.strip
          if v =~ REGEX["class"]
            o["class"] = v
            return o
          end
        end
        raise Exception.new("Invalid value for #{tag} class attribute: #{v} (#{v.class})")
      end # === def tag_attr_class

      def tag_attr_childs(tag : String, o : Hash, k : String, v) : Hash(String, JSON::Type)
        o["childs"] = case v
                      when Array
                        v
                      else
                        raise Exception.new("Invalid value for childs in #{tag}: #{v.class}")
                      end
        o
      end

      def standardize(name : String, origin : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
        new_tag = tag_attr_tag(name, origin, name, origin[name])

        origin.each_key do |k|
          next if k == "tag"
          v = origin[k]

          {% for mod in Markup.constants.select { |x|
            y = Markup.constant(x)
            y.is_a?(TypeNode) && y.has_constant?(:ATTRS)
          } %}
            # Skipping methods like: P.tag_attr_p, DIV.tag_attr_div, etc.
            {% for meth in Markup.constant(mod).constant(:ATTRS).reject { |x| x == mod.downcase } %}
                if name == "{{mod.downcase}}" && k == {{meth}}
                  new_tag = tag_attr_{{meth.id}}(name, new_tag, k, v)
                  next
                end
            {% end %} # === for meth
          {% end %} # == for mod

          raise Exception.new("Invalid key in #{name}: #{k}")
        end # each_key in origin

        new_tag
      end # === def standardize

      def allowed_key_classes(name : String, o : Hash, allowed )
        key_class = o[name]?.class
        return true if allowed.includes?(key_class)
        raise Exception.new("#{name} can not have type: #{key_class}. Allowed: #{allowed}")
      end

      def allowed_keys(name : String, o : Hash, allowed)
        o.keys.each do |k|
          raise Exception.new("Invalid key in #{name}: #{k}") unless allowed.includes?(k)
        end
      end

      def required_keys(name, o : Hash(String, JSON::Type), list)
        list.each do |k|
          raise Exception.new("#{k} is required for #{name}.") unless o.has_key?(k)
        end
      end

      def require_value(name : String, o : Hash(String, JSON::Type), k : String, list)
        required_keys name, o, {k}
        raise Exception.new("Invalid value for #{k} in #{name}: #{o[k]?.class}") unless list.includes?(o[k]?.class)
      end

    end # === module Base


    def self.standardize(o : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
      {% for mod in Markup.constants.select { |x|
        y = Markup.constant(x)
        y.is_a?(TypeNode) && y.has_constant?(:ATTRS)
      } %}
        if o.has_key?("{{mod.downcase}}")
          return {{mod}}.standardize(o)
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
