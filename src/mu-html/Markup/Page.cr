
module Mu_Html
  module Markup
    struct Page

      getter io
      getter origin

      def initialize(@origin : Hash(String, JSON::Type))
        @io = IO::Memory.new
        Fragment.new(@io, self)
      end # === def initialize

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
