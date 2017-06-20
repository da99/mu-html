
module Mu_HTML
  module Markup
    struct Render

      getter parent : Node
      @opts : Hash(Symbol, Bool)

      def default_hash
        {
          :tag => false,
          :attrs => false,
          :tail => false
        } of Symbol => Bool
      end

      def initialize(@parent)
        @opts = default_hash
      end # === def initialize

      def initialize(@parent, tag : Symbol, attr : Symbol)
        @opts = default_hash
        @parent.io << [tag, attr].inspect
      end # === def initialize

      def io
        parent.io
      end

      def keys_should_be_known
        io << " keys should be known "
      end # === def keys_should_be_known

      def render(o : Symbol)
        case o
        when :tail
          start = parent.index
          fin   = parent.tag.size - 1
          while start <= fin
            new_tag = parent.tag[start]
            case new_tag
            when Array(JSON::Type)
              Node.new(io, new_tag, parent.parent_tag, parent.data)
            when String
              io << parent.data[new_tag]
            else
              raise Exception.new("Invalid tag: #{new_tag.inspect}")
            end
            start += 1
          end
          # io << "  the #{o.inspect} "
        else
          raise Exception.new("Unable to render: #{o.inspect}")
        end
      end

      def render_with(*options)
        options.each do |name|
          case name
          when :tag, :attrs, :tail
            @opts[name] = true
          else
            raise Exception.new("Invalid option for rendering: #{name.inspect}")
          end
        end
      end # === def render_with

      def start_and_finish_render(*options)
        render_with(*options) unless options.empty?
        io << "<"
        if @opts[:tag]
          io << parent.tag_name
        end
        if @opts[:attrs]
          io << " attrs "
          keys_should_be_known
        end

        if @opts[:tail]
          io << ">"
          render(:tail)
          finish_render
        else
          io << ">"
        end
      end

      def start_render(*options)
        render_with(*options) unless options.empty?
        if @opts[:tag]
          io << "<"
          io << parent.tag_name
          if @opts[:attrs]
            io << " attrs "
            keys_should_be_known
          end
          io << ">"
        end
      end

      def finish_render
        if @opts[:tag]
          io << "</"
          io << parent.tag_name
          io << ">"
        end
      end

      def data
        parent.data
      end

      def temp(name, v)
        if data.has_key?(name)
          raise Exception.new("Temporary data key already taken: #{name}")
        end
        unless name.is_a?(String)
          raise Exception.new("Invalid name for temp. data: #{name.inspect}")
        end
        data[name] = v
        yield
        data.delete(name)
      end # === def temp

      def for_each(key)
        unless data.has_key?(key)
          raise Exception.new("Missing data for tag: #{parent.tag_name}: #{key}")
        end
        v = data[key]
        case v
        when Hash
          v.each do |k, v|
            yield(k,v)
          end
        when Array
          v.each do |v|
            yield(v)
          end
        else
          raise Exception.new("Data needs to be an Array or Object: #{key}")
        end
      end # === def for_each

    end # === struct Render
  end # === module Markup
end # === module Mu_HTML
