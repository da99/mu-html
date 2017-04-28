
require "./Tag.Key"
require "./Tag.State"

module Mu_Html

  macro def_tag(&block)
    {% name = block.filename.split("/").last.split(".cr").first.downcase  %}
    module Markup
      module Tag
        struct State
          def tag_of_{{name.id}}
            {{yield}}
            keys_should_be_known
            tag
          end
        end
      end
    end # === module Markup
  end # === macro def_Tag

  module Markup
    module Tag

      def self.clean(parent, raw : Hash(String, JSON::Type))
        {% for m in Tag::State.methods.map(&.name).select { |x| x[0..6] == "tag_of_" } %}
          {% meth = m[7..-1].stringify %}
          if raw.has_key?({{meth}})
            t = Tag::State.new({{meth}}, parent, raw)
            t.tag_of_{{meth.id}}
            return t.tag
          end
        {% end %}

        raise Exception.new("Unknown tag with keys: #{raw.keys}")
      end # === def self.tag

    end # === module Tag
  end # === module Markup
end # === module Mu_Html
