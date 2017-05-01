

module Mu_Html
  module Markup

    module Clean_Tags
    end # === module Clean_Tags

    struct Clean

      include Clean_Tags

      getter origin   : Hash(String, JSON::Type)
      getter tag      : Hash(String, JSON::Type)
      getter tag_name : String

      def initialize(@origin, @tag)
        @keys = [] of String

        {% for m in Clean_Tags.methods.map(&.name).select { |x| x[0..6] == "tag_of_" } %}
          {% tag_name = m[7..-1].gsub(/_/, "-").stringify %}
          {% meth     = m[7..-1].stringify %}
          if @tag.has_key?({{tag_name}})
            @tag_name = {{tag_name}}
            tag_of_{{meth.id}}
            return
          end
        {% end %}

        @tag_name = "unknown"
      end # === def initialize

      def markup
        @origin["markup"]
      end

      def tag
        @origin
      end

      def key(k : String)
        @keys << k

        state = Key.new(self, @tag, @tag_name, k)
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

    end # === struct Clean
  end # === module Markup
end # === module Mu_Html
