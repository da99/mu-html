
require "./A"
require "./Tag"
require "./HTML"

# === Include the tags: =======
require "./Page_Title"
require "./P"
require "./DIV"
require "./EACH"
require "./FOOTER"
require "./INPUT"
require "./SPAN"
# =============================

module Mu_Html

  module Markup

    REGEX = {
      id:      /^[a-z0-9\_]+$/,
      class:   /^[a-z0-9\-\_\ ]+$/,
      data_id: /^[a-z0-9\_\.\-]+$/
    }

    def self.clean(data : Hash(String, JSON::Type))
      return nil unless data.has_key?("markup")
      State.new(data)
      nil
    end

    def self.to_html(origin : Hash(String, JSON::Type))
      fin = IO::Memory.new
      tags = origin["markup"]
      case tags
      when Array(JSON::Type)
        to_html(tags)
      else
        raise Exception.new("invalid markup: #{tags.inspect}")
      end
    end # === def self.to_html

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

      getter origin   : Hash(String, JSON::Type)

      def initialize(@origin)
        raw         = @origin["markup"]?
        self_markup = self

        case raw

        when Array(JSON::Type)
          raw.each { | raw_tag |
            case raw_tag
            when Hash(String, JSON::Type)
              Tag.clean(self_markup, raw_tag)
            else
              raise Exception.new("Invalid value: #{raw_tag}")
            end
          }

        when Nil
          raise Exception.new("Invalid markup.")

        else
          raise Exception.new("Markup can only be an Array of tags.")

        end # === case
      end # === def initialize

      def markup
        @origin["markup"]
      end

    end # === struct State

  end # === module Markup
end # === module Mu_Html
