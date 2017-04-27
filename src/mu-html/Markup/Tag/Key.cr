
module Mu_Html
  module Markup

    module A_Empty_String

      def self.==(str : String)
        str.strip.empty?
      end

      def self.==(o)
        false
      end

    end # === class Empty_String

    module A_Non_Empty_String

      def self.==(k)
        v = k.value
        v.is_a?(String) && v.strip.empty?
      end

    end # === module A_Non_Empty_String

    module A_Empty_Array

      def self.==(k)
        v = k.value
        v.is_a?(Array) && v.empty?
      end

    end # === module A_Empty_Array

    module A_Empty_Hash

      def self.==(k)
        v = k.value
        v.is_a?(Hash) && v.empty?
      end

    end # === module A_Empty_Hash

    module A_Nothing

      def self.==(k)
        A_Non_Empty_String.==(k) ||
          A_Empty_Array.==(k) ||
          A_Empty_Hash.==(k) ||
          k.value.nil?
      end

    end # === module A_Nothing

    module A_Class

      def self.==(k)
        v = k.value
        v.is_a?(String) && v =~ REGEX[:class]
      end

    end # === module A_Class

    module A_Data_ID

      def self.==(k)
        v = k.value
        v.is_a?(String) && v =~ REGEX[:data_id]
      end

    end # === module A_Data_ID


    module Tag
      module Key

        struct State

          getter tag_name : String

          def initialize(@tag_name, @o : Hash(String, JSON::Type), @k : String)
          end # === def initialize

          def origin
            @o
          end

          def key
            @k
          end

          def value
            origin[key]
          end

          def value?
            origin[key]?
          end

          def value?(u)
            v = value?
            case v
            when u
              true
            else
              u == self
            end
          end

          def matches?(pattern : Regex)
            return false unless value?.is_a?(String)
            return true if value? =~ pattern
            false
          end # === def is?

          private def o
            @o
          end

          private def k
            @k
          end

          def new(new_key : String, v)
            raise Exception.new("Key already defined: #{new_key}") if o.has_key?(new_key)
            o[new_key] = v
            o
          end # === def create

          def has_key?
            o.has_key?(k)
          end

          def move_to(to : String)
            from = k
            raise Exception.new("Key defined twice in #{tag_name}: #{from}, #{to}") if o.has_key?(to)
            raise Exception.new("Missing key in #{tag_name}: #{key}") unless o.has_key?(from)
            v = o[from]
            o.delete(from)
            o[to] = v
            o
          end

          def delete
            o.delete(k)
            o
          end # === def remove

          def required
            raise Exception.new("Key missing: #{k}") unless o.has_key?(k)
            o
          end # === def required

          def is_invalid
            raise Exception.new("Invalid key in #{tag_name}: #{k} (#{o[k]?.class})")
            o
          end # === def is_invalid

          def is_nothing?
            return true unless o.has_key?(k)
            v = o[k]
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

          def is_data_id?
            return false unless o.has_key?(k)
            v = o[k]
            case v
            when String
              v =~ IS_DATA_ID
            else
              false
            end
          end

          def empty?
            v = o[k]?
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
            o[k] = v.strip
            o
          end

          def to_tags(parent)
            v = value
            case v
            when Array(JSON::Type)
              clean_childs = [] of JSON::Type
              v.each { |x|
                clean_childs << Tag.tag(parent, x)
              }
              clean_childs
            when String
              v
            else
              raise Exception.new("Invalid value for #{tag_name}: #{k} : #{v}")
            end
          end # === def to_tags

        end # === struct State
      end # === module Key
    end # === module Tag
  end # === module Markup
end # === module Mu_Html