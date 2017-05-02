
require "html"

require "./A"
require "./macro"
require "./Clean"
require "./Key"
require "./Page"
require "./Fragment"
require "./Node"


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

      raw = to_array(data)

      case raw

      when Array(JSON::Type)
        raw.each { | raw_tag |
          case raw_tag
          when Hash(String, JSON::Type)
            Clean.new(data, raw_tag)
          else
            raise Exception.new("Invalid value: #{raw_tag}")
          end
        }

      when Nil
        raise Exception.new("Invalid markup.")

      else
        raise Exception.new("Markup can only be an Array of tags.")

      end # === case

      nil
    end

    def self.in_head_tag?(h : Hash(String, JSON::Type))
      h["in-head-tag"]? == true
    end

    def self.includes_head_tags?(h : Hash(String, JSON::Type))
      return true if in_head_tag?(h) 
      return true if h["markup"]? && includes_head_tags?(h["markup"]?)
      false
    end

    def self.includes_head_tags?(tags : Array(JSON::Type))
      return true if tags.any? { |u| in_head_tag?(u) }
      false
    end

    def self.in_head_tag?(u)
      false
    end

    def self.includes_head_tags?(u)
      false
    end

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
end # === module Mu_Html
