
module Mu_Html
  module Markup

    struct Node

      include Clean_Tags

      getter parent_tag : String
      getter data     : Hash(String, JSON::Type)
      getter tag      : Array(JSON::Type)
      getter io       : IO::Memory
      getter tag_name : String
      getter index    : Int32
      getter attrs    : Hash(String, JSON::Type)

      def initialize( @io, @tag, @parent_tag, @data )
        @temp = {} of String => JSON::Type
        v = @tag.first
        @index = 1

        case v
        when String
          @tag_name = v
        else
          @tag_name = "unknown"
          raise Exception.new("Can't render: #{@tag.inspect}")
        end

        raw_attrs = @tag[@index]
        case raw_attrs
        when Hash(String, JSON::Type)
          @attrs = raw_attrs
          @index = @index + 1
        else
          @attrs = {} of String => JSON::Type
        end

        {% for m in Clean_Tags.methods.map(&.name).select { |x| x[0..6] == "tag_of_" } %}
          {% meth = m[7..-1].downcase %}
          if tag_name == {{meth.stringify}}
            tag_of_{{meth.id}}
            return
          end
        {% end %}

        raise Exception.new("Unknown tag: #{@tag_name}")
      end # === def initialize

      def in_head?
        parent_tag == "head"
      end

      def in_body?
        parent_tag == "body"
      end

      def data(name : Symbol)
        @temp[name]
      end

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

      def head?
        @tag[@index]
      end # === def head?

      def head?(target)
        v = head?
        case v
        when target
          true
        else
          target == v
        end
      end # === def head?

      def is_tail?
        @index == (@tag.size - 1)
      end

      def is_tail!
        raise Exception.new("Markup entry has too many values: #{@tag}") unless is_tail?
      end # === def is_tail!

      def is_invalid!
        raise Exception.new("Invalid tag: #{@tag}")
      end # === def is_invalid!

      def shift!(name : Symbol)
        s = Position.new(:shift!, self)
        @index = @index + 1
        with s yield
      end # === def head!

      def tail!
        Position.new(:tail, self)
      end # === def tail!

      def tail!
        t = tail!
        with t yield
      end # === def tail!

      def render(*options)
        r = Render.new(self)
        r.start_and_finish_render(*options)
        self
      end

      def render(*options)
        r = Render.new(self)
        r.start_render(*options)
        with r yield
        r.finish_render
        self
      end

      def attr!(name : String)
        attr = Attr.new(name, self)
        attr.required!
        with attr yield
        self
      end

      def attr?(name : String)
        return unless attrs.has_key?(name)
        case name
        when "id"
          attr = Attr.new(name, self)
          attr.is_invalid unless attr.id?
        when "class"
          attr = Attr.new(name, self)
          attr.is_invalid unless attr.class?
        else
          raise Exception.new("Unable to validate attribute: #{name}")
        end
        self
      end

      def attr?(name : String)
        return self unless @attrs.has_key?(name)
        attr = Attr.new(name, self)
        with attr yield
        self
      end # === def attr?

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
