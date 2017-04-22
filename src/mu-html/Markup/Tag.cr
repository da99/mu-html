

module Mu_Html

  class Markup

    class Tag

      module Macro

        macro tag_name(new_key)
          @@tag_name = {{new_key}}
        end # === macro tag_name

        macro def_tag(&block)

          @@tag_name = {{ @type.name.split(":").last.downcase }}

          def self.tag_name
            @@tag_name
          end

          def self.tag?(raw : Hash) : Bool
            raw.has_key?(tag_name)
          end

          def self.clean(tag)
            {{block.body}}
            tag
          end

        end # === macro def_tag

        macro new_attr(meth, key)
          tag.{{meth.id}} {{key}} do
            {{yield}}
          end
        end # === macro new_attr

        macro attr(key)
          new_attr(:attr, {{key}}) do
            {{yield}}
          end
        end # === macro attr

        macro required(key)
          new_attr(:required, {{key}}) do
            {{yield}}
          end
        end


      end # === module Macro

      getter tag_name : String
      getter origin : Hash(String, JSON::Type)
      getter attributes = ["tag"] of String
      getter parent : Markup | Tag | Nil

      property key : String

      def initialize(@parent : Markup | Tag, @origin : Hash(String, JSON::Type))
        mod = nil
        {%
         for tag in Markup.constants
          .select { |x| Markup.constant(x).is_a?(TypeNode) }
          .select { |x| Markup.constant(x).class.methods.map(&.name.stringify).includes?("tag?") }
        %}

        mod ||= if {{tag.id}}.tag?(@origin)
                  {{tag.id}}
                end

        {% end %}

        raise Exception.new("Unknown tag with keys: #{origin.keys}") unless mod

        @tag_name = mod.tag_name
        @key = tag_name
        raise Exception.new("Invalid attribute in #{tag_name}: tag") if @origin.has_key?("tag")
        @origin["tag"] = tag_name

        mod.clean(self)
        if !invalid_attributes.empty?
          raise Exception.new("Unknown keys specified: #{invalid_attributes} in tag")
        end
      end # === def initialize

      def initialize(raw_parent, raw)
        puts typeof(raw)
        raise Exception.new("Invalid tag: #{raw}")
        @origin = {} of String => JSON::Type
        @tag_name = ""
        @key = ""
      end

      def key=(k : String)
        @key = k
        attributes << k
      end

      def value
        origin[key]
      end

      def to_hash
        origin
      end # === def to_hash

      def required(new_key : String)
        self.key= new_key
        required
        with self yield
        self
      end

      def required
        return true if key == tag_name || origin.has_key?(key)
        raise Exception.new("Missing key in #{tag_name}: #{key} (other keys: #{origin.keys.join(", ")})")
      end

      def attr(k : String)
        return false unless origin.has_key?(k)
        self.key= k
        with self yield
        self
      end

      def move_to(new_key : String)
        raise Exception.new("Key defined twice in #{tag_name}: #{key}, #{new_key}") if origin.has_key?(new_key)
        raise Exception.new("Missing key in #{tag_name}: #{key}") unless origin.has_key?(key)
        v = self.value
        origin.delete(key)
        origin[new_key] = v
      end

      def on(*args)
        return false unless is?(*args)
        with self yield
      end

      def is?(a_nil : Nil) : Bool
        origin[key] == a_nil
      end

      def is?(pattern : Regex) : Bool
        return false unless value.is_a?(String)
        return true if value =~ pattern
        false
      end # === def is?

      def is?(klass : Class) : Bool
        v = value

        case v
        when klass
          return true
        else
          klass == v
        end
      end # === def is?

      def is?(o)
        false
      end

      def is?(*args)
        args.all? { |x| is?(x) }
      end

      def exists? : Bool
        origin.has_key?(key)
      end

      def is_either?(*args)
        args.any? { |x| is?(x) }
      end

      def delete
        origin.delete(key) if exists?
      end

      def should_be(pattern : Regex) : Bool
        v = value
        return true if v.is_a?(String) && v =~ pattern
        raise Exception.new("Invalid value in #{tag_name}: #{key}: #{v}")
      end

      def should_be(ans : Bool) : Bool
        return true if ans
        is_invalid
      end

      def is_invalid()
        raise Exception.new("Invalid key in #{tag_name}: #{key}: (#{origin[key].class})") if origin.has_key?(key)
        true
      end

      def invalid_attributes
        origin.keys - attributes
      end # === def invalid_attributes

      def to_markup
        v = value
        case v
        when Array(JSON::Type)
          clean_childs = [] of JSON::Type
          v.each { |x|
            clean_childs << Tag.new(self, x).to_hash
          }
          origin[key] = clean_childs
        when String
          :ignore
        else
          raise Exception.new("Invalid value for #{tag_name}: #{key} : #{v}")
        end
      end # === def to_markup

    end # === class Tag

  end # === class Markup

end # === module Mu_Html
