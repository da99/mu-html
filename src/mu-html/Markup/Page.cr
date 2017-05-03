
module Mu_Html
  module Markup
    struct Page

      getter io      : IO::Memory
      getter origin  : Hash(String, JSON::Type)
      getter is_page : Bool

      def initialize(@origin)
        @io = IO::Memory.new
        @is_page = Markup.includes_head_tags?(@origin)

        page_head
        Fragment.new(@io, self, Markup.to_array(@origin).select { |t| !Markup.in_head_tag?(t) })
        page_bottom
      end # === def initialize


      def page_head
        return unless @is_page
        @io << "<!DOCTYPE html>\n"
        @io << "<html lang=\"en\">\n"
        @io << "  <head>\n"
        @io << "    <meta charset=\"utf-8\">\n    "
        Fragment.new(
          @io,
          self,
          Markup.to_array(@origin).select { |t|
            Markup.in_head_tag?(t)
          }
        )
        @io << "\n  </head>\n"
        @io << "  <body>\n"
      end # === def page_head

      def page_bottom
        return unless @is_page
        @io << "\n  </body>\n"
        @io << "</html>"
      end # === def page_bottom

      def is_fragment?
        Markup.to_array(@origin).any? { |k, v|
          case v
          when Hash
            v.has_key?("page-title") || v.has_key?("meta")
          else
            false
          end
        }
      end

      def to_s
        @io.to_s
      end

    end # === struct Page
  end # === module Markup
end # === module Mu_Html
