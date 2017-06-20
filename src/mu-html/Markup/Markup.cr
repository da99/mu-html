
require "html"

require "./A"
require "./macro"
require "./Clean"
require "./Key"
require "./Page"
require "./Node"
require "./Attr"
require "./Position"
require "./Render"


# === Include the tags: =======
require "./tags/TITLE"
require "./tags/P"
require "./tags/DIV"
require "./tags/EACH"
require "./tags/FOOTER"
require "./tags/INPUT"
require "./tags/SPAN"
require "./tags/IF"
# =============================

module Mu_HTML
  module Markup

    DATA_ID_INVALID = /[^a-zA-Z\.\_\-0-9]+/

    REGEX = {
      id:      /^[a-z0-9\_]+$/,
      class:   /^[a-z0-9\-\_\ ]+$/,
      data_id: /^[a-zA-Z0-9\_\.\-]+$/
    }

    def self.clean(data : Hash(String, JSON::Type))
      raw = data["markup"]?
      case raw
      when Array(JSON::Type)
        true
      when Nil
        true
      else
        raise Exception.new("Invalid value for markup: #{raw.inspect}")
      end # === case
    end # === def self.clean

    def self.to_template_var(keys : Array(String))
      "{{" + keys.join(".") + "}}"
      "{{" + keys.join(".") + "}}"
    end # === def self.to_template_var

    def self.to_s(origin : Hash(String, JSON::Type), target : Hash(Symbol, String))
      return "" unless origin["markup"]?
      target[:html] = to_html(origin)
      target
    end # === def self.to_s

    def self.to_html(origin : Hash(String, JSON::Type))
      Page.new(origin).to_s
    end # === def self.to_html

    def self.to_array(raw : Hash(String, JSON::Type)) : Array(JSON::Type)
      r = raw["markup"]
      case r
      when Array(JSON::Type)
        tags = r
      else
        tags = [] of JSON::Type
        raise Exception.new("invalid markup: (#{r.class}) #{r.inspect}")
      end
      tags
    end


  end # === module Markup
end # === module Mu_HTML
