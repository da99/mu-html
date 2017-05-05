
module Mu_Html
  module Markup

    struct Node

      getter parent   : Fragment
      getter tag      : Hash(String, JSON::Type)
      getter io       : IO::Memory
      getter tag_name : String

      def initialize( @io, @tag, @parent )
        v = @tag["tag"]?

        case v
        when String
          @tag_name = v
        else
          @tag_name = "unknown"
          raise Exception.new("Can't render: #{@tag.inspect}")
        end

        {% for m in Node.methods.map(&.name).select { |x| x[0..7] == "to_html_" } %}
          {% meth = m[8..-1].downcase %}
          if tag_name == {{meth.stringify}}
            to_html_{{meth.id}}
            return
          end
        {% end %}

        to_html_tag
      end # === def initialize

      def node
        @tag
      end

      def origin
        parent.parent.origin
      end

      def data
        v = origin["data"]
        case v
        when Hash(String, JSON::Type)
          :ignore
        else
          {} of String => JSON::Type
        end
        v
      end # === def data

      def tag(*attrs)
        @io << "<"
        @io << tag_name
        unless attrs.empty?
          @io << to_attrs(*attrs)
        end
        @io << ">"
        yield
        @io << "</"
        @io << tag_name
        @io << ">"
        @io
      end

      def escape(v : String | Int32 | Int64)
        Markup.escape(v)
      end

      def escape(u)
        raise Exception.new("Invalid value for rendering: #{u.inspect}")
      end

      def to_attrs(*keys)
        str = IO::Memory.new
        @tag.select { |k| keys.includes?(k) }.each do |k, v|
          case k
          when String
            case v
            when String
              str << " " if str.empty?
              str << k
              str << "="
              str << ::HTML.escape(v).inspect
              next
            end
            raise Exception.new("Invalid value for attribute: #{k}: #{v} (#{v.class})")
          else
            raise Exception.new("Invalid value for attribute tag: #{k} (#{k.class})")
          end
        end

        str.to_s
      end

      def to_s
        str = @io.to_s
        str
      end # === def to_s

      def string_or_tags
        string_or_tags("body")
      end

      def string_or_tags(k : String)
        return unless @tag.has_key?(k)
        v = @tag[k]
        case v
        when String
          @io << Data.get(data, v)
        when Array(Hash(String, JSON::Type)), Array(JSON::Type)
          v.each { |r|
            case r
            when Hash(String, JSON::Type)
              Node.new(@io, r, parent)
            else
              raise Exception.new("invalid value for inner HTML: #{v.inspect}")
            end
          }
        else
          raise Exception.new("Invalid value for content: #{v} (#{v.class})")
        end
      end # === def self.string_or_tags

      def to_html_tag
        tag("id", "class") do
          string_or_tags
        end
      end

      def page_title(str : String)
        raise Exception.new("not ready")
      end # === def page_title

      def to_s
        @io.to_s
      end

    end # === struct Node
  end # === module Markup
end # === module Mu_Html
