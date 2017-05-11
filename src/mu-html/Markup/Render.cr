
module Mu_Html
  module Markup
    struct Render

      getter parent : Node

      def initialize(@parent)
        render
      end # === def initialize

      def initialize(@parent, tag : Symbol)
        @parent.io << tag.inspect
        render
      end # === def initialize

      def initialize(@parent, tag : Symbol, attr : Symbol)
        @parent.io << [tag, attr].inspect
        render
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

      def render
        io << "render the node"
      end

      def render(k : Symbol)
        io << "render #{k}"
      end # === def render

      def render(names : Tuple(Symbol, Symbol))
        case names
        when {:tag, :attrs}
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

      def render(names : Tuple(Symbol))
        case names
        when {:tag}
          :ignore
        else
          raise Exception.new("Unable to render #{names} for tag: #{@parent.tag.inspect}")
        end

        io << "<"
        io << @parent.tag_name
        io << ">"

        keys_should_be_known
        io << "</"
        io << @parent.tag_name
        io << ">"
      end # === def render

      def data
        v = parent.parent.parent.origin["data"]
        case v
        when Hash
          v
        else
          raise Exception.new("Data not found for page.")
        end
      end # === def data

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
end # === module Mu_Html
