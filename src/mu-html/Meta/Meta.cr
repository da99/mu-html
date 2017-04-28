
module Mu_Html

  module Meta

    SECTIONS = {"title", "layout"}

    def self.clean(json : Hash)
      return(nil) unless json.has_key?("meta")

      meta = json["meta"]
      case meta
      when Hash(String, JSON::Type)

        Base.allowed_keys("meta", SECTIONS, meta)
        valid_meta = {} of String => String | Int32 | Int64

        meta.each do |key, value|
          case key
          when String
            raise Exception.new("invalid meta key: #{key}") unless SECTIONS.includes?(key)

            case value
            when String, Int64
              valid_meta[key] = value
            else
              raise Exception.new("invalid value for meta[#{key}]")
            end

          else
            raise Exception.new("invalid meta key: not a string")
          end
        end
      else
        raise Exception.new("invalid meta")
      end

      valid_meta
    end # def self.parse

  end # === module Meta

end # === module Mu_Html
