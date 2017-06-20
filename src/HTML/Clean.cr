

module Mu_WWW_HTML
  module Markup

    module Clean_Tags
    end # === module Clean_Tags

    struct Clean

      include Clean_Tags

      getter origin   : Hash(String, JSON::Type)
      getter tag      : Hash(String, JSON::Type)
      getter tag_name : String
      getter keys     : Array(String)

      def initialize(@origin, @tag)
        @keys = ["in-tag-head"] of String
        @tag_name = "unknown"
        clean_tag!
        @tag["tag"] = @tag_name unless @tag.has_key?("tag")
      end # === def initialize

      private def clean_tag!
        {% for m in Clean_Tags.methods.map(&.name).select { |x| x[0..6] == "tag_of_" } %}
          {% tag_name = m[7..-1].gsub(/_/, "-").stringify %}
          {% meth     = m[7..-1].stringify %}
          if @tag.has_key?({{tag_name}})
            @tag_name = {{tag_name}}
            tag_of_{{meth.id}}
            return
          end
        {% end %}
        raise Exception.new("Unknown tag: #{@tag.inspect}")
      end # === def clean_tag!

      def markup
        @origin["markup"]
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
        @tag.each_key do |k|
          Key.new(self, @origin, @tag_name, k).is_invalid unless @keys.includes?(k)
        end
      end # === def keys_should_be_known

    end # === struct Clean
  end # === module Markup
end # === module Mu_WWW_HTML
