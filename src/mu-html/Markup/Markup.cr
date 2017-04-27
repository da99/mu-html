
require "./macro"
require "./Base"
require "./Tag/Tag"

# === Include the tags: =======
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
      id: /^[a-z0-9\_]+$/,
      class: /^[a-z0-9\-\_\ ]+$/,
      data_id: /^[a-z0-9\_\.\-]+$/
    }

    def self.markup(data : Hash(String, JSON::Type))
      State.new(data).origin["markup"]
    end

    struct State

      getter origin   : Hash(String, JSON::Type)

      def initialize(@origin)
        raw         = @origin["markup"]?
        self_markup = self

        case raw

        when Array(JSON::Type)
          raw.each { | raw_tag |
            Tag.tag(self_markup, raw_tag)
          }

        when Nil
          raise Exception.new("Invalid json.")

        else
          raise Exception.new("Markup can only be an Array of tags.")

        end # === case
      end # === def initialize

    end # === struct State

  end # === module Markup
end # === module Mu_Html
