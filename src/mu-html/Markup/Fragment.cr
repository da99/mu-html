

module Mu_Html
  module Markup
    struct Fragment

      getter io     : IO::Memory
      getter parent : Page
      getter tags   : Array(JSON::Type)
      getter parent_tag : String

      def initialize(@io, @parent, @parent_tag, @tags)
        render
      end # === def initialize

      def initialize(@io, @parent, @parent_tag)
        @tags     = Markup.to_array(parent.origin)
        render
      end # === def initialize

      def render
        this_fragment = self
        @tags.each { |t|
          case t
          when Array
            Node.new(@io, t, this_fragment)
          else
            raise Exception.new("Invalid tag: #{t.inspect}")
          end
        }
      end # === def render

      def to_s
        @io.to_s
      end

    end # === struct Fragment
  end # === module Markup
end # === module Mu_Html
