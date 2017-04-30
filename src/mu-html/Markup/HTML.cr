
require "html"

module Mu_Html

  macro def_html(&block)
    {% name = block.filename.split("/").last.split(".cr").first.downcase %}
    module Markup
      module HTML
        struct State
          def to_html_{{name.id}}
            {{yield}}
          end
        end
      end # === module HTML
    end # === module Markup
  end # === macro def_html

  module Markup

    module HTML

      def self.to_html(tags : Array(JSON::Type))
        fin = IO::Memory.new
        tags.each do |t|
          case t
          when Hash(String, JSON::Type)
            fin << HTML::State.new(t).to_s
          else
            raise Exception.new("invalid tag: #{t.class}")
          end
        end
        fin.to_s
      end # === def self.to_html

      struct State

        getter tag_name
        getter io

        def initialize(@origin : Hash(String, JSON::Type))
          @io = IO::Memory.new

          v = @origin["tag"]?
          case v
          when String
            @tag_name = v
          else
            @tag_name = "unknown"
            raise Exception.new("tag name not found: #{@origin.keys}")
          end

          {% for m in HTML::State.methods.map(&.name).select { |x| x[0..7] == "to_html_" } %}
            {% meth = m[8..-1].downcase %}
            if tag_name == {{meth.stringify}}
              to_html_{{meth.id}}
              return
            end
          {% end %}
          to_html_tag
        end # === def initialize

        def about
          @origin
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

        def to_attrs(*keys)
          h = @origin
          str = IO::Memory.new
          h.select { |k| keys.includes?(k) }.each do |k, v|
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
        end # === def to_html

        def string_or_tags
          string_or_tags("body")
        end

        def string_or_tags(k : String)
          return unless @origin.has_key?(k)
          h = @origin
          v = h[k]
          case v
          when String
            @io << v
          when Array(Hash(String, JSON::Type)), Array(JSON::Type)
            @io << HTML.to_html(v)
          else
            raise Exception.new("Invalid value for content: #{v} (#{v.class})")
          end
        end # === def self.string_or_tags

        def to_html_tag
          tag("id", "class") do
            string_or_tags
          end
        end

      end # === struct State
    end # === module HTML
  end # === module Markup
end # === module Mu_Html
