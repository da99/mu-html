
module Mu_Html
  module Markup
    struct Key

      getter parent   : Markup::Clean
      getter tag      : Hash(String, JSON::Type)
      getter tag_name : String
      getter key      : String

      def initialize(@parent, @tag, @tag_name, @key)
      end # === def initialize

      def value
        tag[key]
      end

      def value?
        tag[key]?
      end

      def value?(u)
        v = value?
        case v
        when u
          true
        else
          u == v
        end
      end

      def matches?(pattern : Regex)
        return false unless value?.is_a?(String)
        return true if value? =~ pattern
        false
      end # === def is?

      private def o
        @tag
      end

      def new(new_key : String, v)
        raise Exception.new("Key already defined: #{new_key}") if tag.has_key?(new_key)
        tag[new_key] = v
        tag
      end # === def create

      def has_key?
        tag.has_key?(key)
      end

      def in_tag_head!
        @tag["in-tag-head"] = true
      end

      def change_tag_to(s : String)
        @parent.keys << "tag"
        @tag["tag"] = s
      end

      def move_to(to : String)
        from = key
        raise Exception.new("Key defined twice in #{tag_name}: #{from}, #{to}") if tag.has_key?(to)
        raise Exception.new("Missing key in #{tag_name}: #{key}") unless tag.has_key?(from)
        v = tag[from]
        tag[to] = v
        tag.delete(from)
        tag
      end

      def delete
        tag.delete(key)
        o
      end # === def remove

      def required
        raise Exception.new("Key missing: #{key}") unless tag.has_key?(key)
        o
      end # === def required

      def is_invalid
        raise Exception.new("Invalid key in #{tag_name}: #{key}: #{value?.inspect[0..20]} (#{value?.class})")
        o
      end # === def is_invalid

      def is_nothing?
        return true unless tag.has_key?(key)
        v = tag[key]
        case v
        when String
          v.strip.empty?
        when Array, Hash
          v.empty?
        when Nil
          true
        else
          false
        end
      end

      def empty?
        v = tag[key]?
          case v
        when String
          v.strip.empty?
        when Hash, Array
          v.empty?
        else
          false
        end
      end

      def strip
        v = value
        case v
        when String
          tag[key] = v.strip
        else
          raise Exception.new("Not a string: #{key}")
        end
        o
      end

      def to_tags
        this_state = self
        v = value
        case v
        when Array(Hash(String, JSON::Type)), Array(JSON::Type)
          clean_childs = [] of JSON::Type
          v.each { |x|
            case x
            when Hash(String, JSON::Type)
              clean_childs << Clean.new(@parent.origin, x).tag
            else
              raise Exception.new("Invalid value for body: #{x}")
            end
          }
          tag[key] = clean_childs
          o
        when String
          o
        else
          raise Exception.new("Invalid value for #{tag_name}: #{key} : #{v} #{typeof(v)}")
        end
      end # === def to_tags

    end # === struct Key
  end # === module Markup
end # === module Mu_Html
