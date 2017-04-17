
module Mu_Html

  module Markup

    module EACH

      extend Base
      extend self

      def validate(o : Hash(String, JSON::Type))
        o = validate_attrs o, "each", "as", "in", "body"
        o = required_attrs o, "each", "as", "in", "body"
        o
      end # === def standardize

      def_attr "each" do
        move_if "in", String
      end # === validate_attr "each"

      def tag_attr_in(o : Hash) : Hash(String, JSON::Type)
        k = "in"
        v = o[k]
        tag = tag_name
        case v
        when String
          v = v.strip
          if !v.empty?
            o["in"] = v
            return o
          end
        end
        raise Exception.new("Invalud value for each in: #{v} (#{v.class})")
      end # === def tag_attr_in

      def tag_attr_as(o : Hash) : Hash(String, JSON::Type)
        k = "as"
        tag = tag_name
        raw = o[k]
        case raw
        when String
          tag_value = raw.strip
          if !tag_value.empty?
            return o if raw == tag_value
            o[tag] = tag_value
            return o
          end
        end
        raise Exception.new("Invalid value for each as: #{raw} #{raw.class}")
      end

      def tag_attr_loop(o : Hash) : Hash(String, JSON::Type)
        k = "loop"
        v = o[k]
        tag = tag_name
        case v
        when Array(JSON::Type)
          return o
        end
        raise Exception.new("Invalid type for #{tag} #{k}: #{v.class}")
      end # === def tag_attr_loop

    end # === module EACH

  end # === module Markup

end # === module Mu_Html
