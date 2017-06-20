

module Mu_HTML
  module Markup
    struct Fragment

      getter io     : IO::Memory
      getter data   : Hash(String, JSON::Type)
      getter tags   : Array(JSON::Type)
      getter parent_tag : String

      def initialize(@io, @data, @parent_tag, @tags)
        render
      end # === def initialize

      def render
        me = self
        @tags.each { |t|
          case t
          when Array
            Node.new(@io, t, parent_tag, data)
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
end # === module Mu_HTML
