
module Mu_Html

  module Markup

    class Tag

      getter tag_name : String
      getter origin : Hash(String, JSON::Type)
      property key : String | Nil

      def initialize(@tag_name : String, @origin : Hash(String, JSON::Type))
        raise Exception.new("Invalid key in #{tag_name}: tag") if @origin.has_key?("tag")
        origin["tag"] = @tag_name
      end

      def initialize(@tag_name : String, @origin : Hash(String, JSON::Type), @key : String)
      end

      def attr(k : String)
        return false unless origin.has_key?(k)
        self.key= k
        with self yield
        self
      end

      def delete_if(klass : Class)
        o = origin
        k = key
        return o unless o.has_key?(k)
        v = o[k]

        case v
        when klass
          v
        else
          return o unless klass.responds_to?(:is?)
          return o unless klass.is?(v)
        end

        o.delete k
        o
      end

      def delete_if(a_nil : Nil)
        o = origin
        k = key
        return o unless o.has_key?(k)
        return o unless o[k] == nil
        o.delete(k)
        o
      end

      def dsl
        with self yield
      end

      def move_to(new_key : String)
        raise Exception.new("Key defined twice in #{tag_name}: #{key}, #{new_key}") if origin.has_key?(new_key)
        raise Exception.new("Missing key in #{tag_name}: #{key}") unless origin.has_key?(key)
        v = origin[key]
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
        return false unless origin[key].is_a?(String)
        return true if origin[key] =~ pattern
        false
      end # === def is?

      def is?(klass : Class) : Bool
        v = origin[key]

        case v
        when klass
          true
        else
          if klass.responds_to?(:is?)
             return klass.is?(v)
          end
        end

        false
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

      def required
        raise Exception.new("Missing key in #{tag_name}: #{key}") unless origin.has_key?(key)
      end

      def delete
        origin.delete(key) if exists?
      end

      def should_be(pattern : Regex) : Bool
        v = origin[key]
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

    end # === class Tag

  end # === module Markup

end # === module Mu_Html
