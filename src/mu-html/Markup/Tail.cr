
module Mu_Html
  module Markup
    struct Tail

      getter parent : Node

      def initialize(@parent)
        raise Exception.new("Tail is required for tag: #{parent.tag}") if empty?
      end # === def initialize

      def index
        @parent.index
      end

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

    end # === struct
  end # === module Markup
end # === module Mu_Html
