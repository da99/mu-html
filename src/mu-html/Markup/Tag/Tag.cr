
require "./Key"

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
      struct State

        def initialize(@tag_name : String, @parent : Key::State | Markup::State, @origin : Hash(String, JSON::Type))
          @keys = ["tag"] of String
          raise Exception.new("Invalid tag: #{@tag_name}: tag") if @origin.has_key?("tag")
          @origin["tag"] = @tag_name
        end # === def initialize

        def tag
          @origin
        end

        def key(k : String)
          @keys << k

          state = Key::State.new(@tag_name, @origin, k)
          with state yield(state)

          @origin
        end # === def key

        def key?(k : String)
          @keys << k
          return @origin unless @origin.has_key?(k)

          key(k) do |state|
            with state yield
          end

          @origin
        end

        def keys_should_be_known
          @origin.each_key do |k|
            Key::State.new(@tag_name, @origin, k).is_invalid unless @keys.includes?(k)
          end
        end # === def keys_should_be_known

      end # === struct State

      def self.tag(parent, raw : Hash(String, JSON::Type))
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
