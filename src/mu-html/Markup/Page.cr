
module Mu_HTML
  module Markup
    struct Page

      getter io      : IO::Memory
      getter origin  : Hash(String, JSON::Type)
      getter is_page : Bool
      getter data    : Hash(String, JSON::Type)

      def initialize(@origin)
        @io = IO::Memory.new
        @is_page = true

        data = origin["data"]
        if !data.is_a?(Hash(String, JSON::Type))
          raise Exception.new("Invalid data.")
        end

        @data = data

        page_head
        Node.many(Markup.to_array(@origin), io, "body", data)
        page_bottom
      end # === def initialize


      def page_head
        return unless @is_page
        @io << "<!DOCTYPE html>\n"
        @io << "<html lang=\"en\">\n"
        @io << "  <head>\n"
        @io << "    <meta charset=\"utf-8\">\n    "
        Node.many(
          Markup.to_array(@origin),
          io,
          "head",
          data
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
end # === module Mu_HTML
