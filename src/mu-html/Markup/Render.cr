
module Mu_Html
  module Markup
    struct Render

      getter parent : Node

      def initialize(@parent, args)
        @parent.io << args.inspect
        render args
      end # === def initialize

      def io
        parent.io
      end

      def tail
        io << "tail!"
      end

      def keys_should_be_known
        io << "keys should be known\n"
      end # === def keys_should_be_known

      def render(names : Tuple(Symbol))
        case names
        when {:tag}, {:tag, :attrs}
          :ignore
        else
          raise Exception.new("Unable to render #{names} for tag: #{@parent.tag.inspect}")
        end

        io << "<"
        io << @parent.tag_name
        io << " attrs! " if names == {:tag, :attrs}
        io << ">"

        keys_should_be_known
        io << "</"
        io << @parent.tag_name
        io << ">"
      end # === def render

    end # === struct Render
  end # === module Markup
end # === module Mu_Html
