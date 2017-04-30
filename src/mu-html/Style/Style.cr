
module Mu_Html
  module Style

    def self.to_style(json : Hash(String, JSON::Type))
      style = json["style"]
      return nil unless style
      case style
      when Hash(String, JSON::Type)
        State.new(style).to_s
      else
        raise Exception.new("Invalid value for style: #{style}")
      end
    end # === def self.to_style

    def self.clean(json)
      nil
    end

    struct State

      COMMON_ID = /[\#\.a-z0-9\-\_]+/
      COMMON_VALUE = /[\!a-z0-9\-\_\ ]+/

      def to_s
        append(@origin)
        @io.to_s
      end # === def to_s

      private def spacer
        @indent.times do |i|
          @io << " "
        end
      end # === def spacer

      private def append(k, v)
        spacer
        @io << k

        spacer
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
      end # === def to_s(v)

      def initialize(@origin : Hash(String, JSON::Type))
        @io = IO::Memory.new
        @indent = 0
        clean
      end # === def initialize

      def clean?(k, v)
        case
        when k.is_a?(String) && v.is_a?(String) && k =~ COMMON_ID && v =~ COMMON_VALUE
          true
        when k.is_a?(String) && k =~ COMMON_ID && v.is_a?(Hash)
          v.all? { |ik, iv| clean?(ik, iv) }
        else
          false
        end
      end # === def clean?

      def clean
        @origin.each { |k, v|
          if !clean?(k,v)
            raise Exception.new("Invalid value: #{k}, #{v}")
          end
        }
      end # === def clean

    end # === struct State
  end # === module Style
end # === module Mu_Html
