
module Mu_WWW_HTML
  module Style

    COMMON_ID = /[\#\.a-z0-9\-\_]+/
    COMMON_VALUE = /[\!a-z0-9\-\_\ ]+/

    def self.to_s(json : Hash(String, JSON::Type), target : Hash(Symbol, String))
      content = to_css(json)
      return "" unless content
      target[:css] = content
      target
    end # === def self.to_s

    def self.to_css(json : Hash(String, JSON::Type))
      style = json["style"]?
      return nil unless style
      case style
      when Hash(String, JSON::Type)
        State.new(style).to_css
      else
        raise Exception.new("Invalid value for style: #{style}")
      end
    end # === def self.to_style

    def self.clean(json : Hash(String, JSON::Type))
      raw = json["style"]?
      return json unless raw
      case raw
      when Hash(String, JSON::Type)
        raw.each { |k, v|
          unless clean?(k,v)
            raise Exception.new("Invalid value: #{k}, #{v}")
          end
        }
      end
      json
    end # === def self.clean

    def self.clean?(k, v)
      case
      when k.is_a?(String) && v.is_a?(String) && k =~ COMMON_ID && v =~ COMMON_VALUE
        true
      when k.is_a?(String) && k =~ COMMON_ID && v.is_a?(Hash)
        v.all? { |ik, iv| clean?(ik, iv) }
      else
        false
      end
    end # === def self.clean?

    struct State

      getter origin

      def to_css
        append(@origin)
        @io.to_s
      end # === def to_css

      private def spacer
        @indent.times do |i|
          @io << " "
        end
      end # === def spacer

      private def append(k, v)
        spacer
        @io << k

        case v
        when String
          @io << ": "
          @io << v
          @io << ";\n"
        else
          @io << " {\n"
          @indent += 1
          append(v)
          @indent -= 1
          spacer
          @io << "}\n"
        end
      end # === def append(k, v)

      private def append(v)
        case

        when v.is_a?(Hash)
          v.each { |k, iv|
            append(k, iv)
          }

        else
          raise Exception.new("Invalid value: #{v.inspect}")

        end # === case
      end # === def appead(v)

      def initialize(@origin : Hash(String, JSON::Type))
        @io = IO::Memory.new
        @indent = 0
      end # === def initialize

    end # === struct State
  end # === module Style
end # === module Mu_WWW_HTML
