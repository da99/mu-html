
require "./Key"

module Mu_Html
  module Markup
    module Tag

      TAGS = [] of String

      macro extended
        {{ Tag::TAGS << @type.name.stringify }}
      end # === macro extended

      struct State

        @tag_name : String
        @keys : Array(String)

        def initialize(@tag_name, @origin : Hash(String, JSON::Type))
          @keys = ["tag"]
        end # === def initialize

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

      # ====================================================================
      # ====================================================================

      def self.tag(parent : Markup::State | Tag::State, origin : Hash(String, JSON::Type))
        {%
         for tag in @type.constant(:TAGS)
        %}

        if {{tag.id}}.tag?(origin)
          return {{tag.id}}.tag(parent, origin)
        end

        {% end %}

        raise Exception.new("Unknown tag with keys: #{origin.keys}")
      end # === def initialize

      def self.tag(*args)
        raise Exception.new("Invalid tag: #{args.last}")
      end # === def tag

      def tag_name
        {{ @type.name.downcase.split("::").last }}
      end

      def tag?(raw : Hash)
        raw.has_key?(tag_name)
      end

      def clean(o : Hash(String, JSON::Type))
        o_state = State.new(tag_name, o)
        with o_state yield
        o["tag"] = tag_name unless o.has_key?("tag")
        o_state.keys_should_be_known
      end # === def clean

    end # === module Tag
  end # === module Markup
end # === module Mu_Html
