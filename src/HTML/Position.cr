
module Mu_WWW_HTML
  module Markup
    struct Position
      getter parent : Node
      getter name   : Symbol
      getter index  : Int32

      def initialize(@name, @parent)
        @index = parent.index
        raise Exception.new("Head is required for tag: #{parent.tag}") if empty?
      end # === def initialize

      def last_index
        @parent.tag.size - 1
      end

      def size
        @parent.tag.size - index
      end

      def empty?
        size < 1
      end

      def is_single_value?
        size == 1
      end

      def single_value!
        raise Exception.new("Body can only consist of a single value for tag: #{parent.tag.inspect}") unless is_single_value?
      end

      def value
        return @parent.tag[index] if is_single_value?
        @parent.tag[index..last_index]
      end

      def is_invalid!
        raise Exception.new("Value is invalid for: #{parent.tag_name}: #{value?}")
      end # === def is_invalid!

      def value?
        @parent.tag[index]?
      end # === def value?

    end # === struct Head
  end # === module Markup
end # === module Mu_WWW_HTML
