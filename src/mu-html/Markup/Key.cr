
module Mu_Html
  module Markup
    struct Key


        getter tag_name : String
        getter parent   : Markup::Clean

        def initialize(@parent, @tag : Hash(String, JSON::Type), @tag_name, @k : String)
        end # === def initialize

        def origin
          @tag
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
            u == value?
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

        def page_title(v : String)
          parent.origin["markup.meta"]["title"] = v
        end

        def move_to(to : String)
          from = k
          raise Exception.new("Key defined twice in #{tag_name}: #{from}, #{to}") if o.has_key?(to)
          raise Exception.new("Missing key in #{tag_name}: #{key}") unless o.has_key?(from)
          v = o[from]
          o[to] = v
          o.delete(from)
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
          raise Exception.new("Invalid key in #{tag_name}: #{k}: #{value?.inspect[0..10]} (#{value?.class})")
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
          v = value
          case v
          when String
            o[k] = v.strip
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
                clean_childs << Tag.clean(this_state, x)
              else
                raise Exception.new("Invalid value for body: #{x}")
              end
            }
            o[k] = clean_childs
            o
          when String
            o
          else
            raise Exception.new("Invalid value for #{tag_name}: #{k} : #{v} #{typeof(v)}")
          end
        end # === def to_tags

    end # === struct Key
  end # === module Markup
end # === module Mu_Html
