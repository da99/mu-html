
require "html"

module Mu_Html
  module Markup

    macro def_html(&block)
      {% name = block.filename.split("/").last.split(".cr").first.downcase %}
      module HTML
        struct State
          def to_html_{{name.id}}
            {{yield}}
          end
        end
      end # === module HTML
    end # === macro def_html

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

        def initialize(@origin : Hash(String, JSON::Type))
          @str = IO::Memory.new

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

        def tag
          body = yield
          @str << "<"
          @str << tag_name
          @str << ">"
          @str << body
          @str << "</"
          @str << tag_name
          @str << ">"
          @str
        end

        def tag(*attrs)
          body = yield
          @str << "<"
          @str << tag_name
          @str << to_attrs(*attrs)
          @str << ">"
          @str << body
          @str << "</"
          @str << tag_name
          @str << ">"
          @str
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
          @str.to_s
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
            v
          when Array(Hash(String, JSON::Type)), Array(JSON::Type)
            str = HTML.to_html(v)
            str
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
