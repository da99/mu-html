
module Mu_Html
  module Markup
    struct Attr

      getter name : String
      getter parent : Node

      def initialize(@name, @parent)
      end # === def initialize

      def value
        @parent.attrs[@name]
      end # === def value

      def value?
        @parent.attrs[@name]?
      end

      def matches?(r : Regex)
        v = value
        return false unless v.is_a?(String)
        v =~ r
      end # === def matches?

      def value?(klass)
        v = value?
        case v
        when klass
          true
        else
          klass.==(v)
        end
      end # === def value?

      def id?
        value =~ REGEX[:id]
      end # === def id?

      def class?
        value =~ REGEX[:class]
      end # === def class?

      def data_id?
        value =~ REGEX[:data_id]
      end # === def data_id?

      def is_invalid
        raise Exception.new("Invalid tag attribute in #{parent.tag_name}: #{name}: #{value?}")
        self
      end # === def is_invalid

      def required!
        unless parent.attrs.has_key?(name)
          raise Exception.new("Tag attribute required: #{parent.tag_name}: #{name}")
        end
      end # === def required!

    end # === struct Attr
  end # === module Markup
end # === module Mu_Html
