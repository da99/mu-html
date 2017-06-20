
module Mu_Clean
  module Attr

    extend self

    def self.invalid(tag_name, name, val)
      raise Exception.new("Invalid attribute: #{tag_name.inspect}.#{name.inspect} = #{val.inspect}")
    end # === def invalid_attr

    def name(tag_name : String, val : String)
      case tag_name
      when "input"
        return val if val =~ /^[a-zA-Z0-9\_\-]+$/
      end
      nil
    end # === def attr_name

    def type(tag_name : String, val)
      case
      when tag_name == "input" && val == "hidden"
        return "hidden"
      end # === case tag_name
      nil
    end # === def attr_type

    def value(tag_name : String, val : String)
      case
      when tag_name == "input" && val =~ /^[a-zA-Z0-9\_\ \-\.]+$/
        return val
      end

      nil
    end # === def attr_value

    def class(tag_name : String, val)
      case
      when val.is_a?(String) && val =~ /^[a-zA-Z0-9\_\ ]+$/
        return val
      end

      nil
    end # === def attr_class

    def href(tag_name : String, val : String)
      case
      when tag_name == "a"
        return Mu_Clean.uri(val)
      end

      nil
    end # === def href

    def action(tag_name : String, val : String)
      case
      when tag_name == "form" && val =~ /^\/[a-zA-Z0-9\.\_\-\/]+$/
        return Mu_Clean.uri(val)
      end

      nil
    end # === def action

    # For security reasons, "refresh" is left out.
    def http_dash_equiv(tag_name, val)
      # ==
      return nil if tag_name != "meta"
      case val
      when "content-security-policy", "content-type", "set-cookie"
        return val
      end
      nil
    end # === def http_dash_equiv

    def content(tag_name, val)
      case
      when tag_name == "meta"
        return val
      end

      nil
    end # === def content

    def clean(tag, attrs : Hash(String, String))
      attrs.keys.each do |name|
        val  = attrs[name]
        return nil if !val

        new_val = case
                  when name == "id"
                    val =~ /^[a-z0-9\_\-]+$/i && val
                  when tag == "input" && name == "name"
                    val =~ /^[a-zA-Z0-9\_\-]+$/ && val

                  when tag == "input" && name == "value"
                    val =~ /^[a-zA-Z0-9\_\ \-\.]+$/ && val

                  when tag == "input" && name == "type" && val == "hidden"
                    "hidden"

                  when tag == "script" && name == "defer"
                    (val =~ /true|false/i) && val

                  when tag == "script" && name == "src"
                    Mu_Clean.uri(val)

                  when tag == "script" && name == "async"
                    (val =~ /true|false/i) && val

                  when tag == "script" && name == "src"
                    val =~ /^[a-z0-9\_\.\/]+$/i && val

                  when name == "class"
                    val.is_a?(String) && val =~ /^[a-zA-Z0-9\_\ ]+$/ && val

                  when tag == "link" && name == "href"
                    val =~ /^\/[a-zA-Z\.0-9\-\_\/]+$/ && Mu_Clean.uri(val)

                  when tag == "link" && name == "rel"
                    val =~ /^[a-zA-Z0-9\ ]+$/ && val

                  when tag == "link" && name == "title"
                    val =~ /^[a-zA-Z0-9\ \_\-\.]+$/ && val

                  when tag == "link" && name == "type" && val =~ /^text\/css;?$/i
                    val

                  when tag == "link" && name == "media" && val =~ /^[\(\)\-\:\ a-zA-Z0-9]+$/

                  when tag == "a" && name == "href"
                    Mu_Clean.uri(val)

                  when tag == "form" && name == "action"
                    val =~ /^\/[a-zA-Z0-9\.\_\-\/]+$/ && Mu_Clean.uri(val)

                  when tag == "meta" && name == "http-equiv" && val =~ /^content-security-policy$/i
                    content = attrs["content"]?
                    content.is_a?(String) && content =~ /^[a-zA-Z\;\:\/\ \*\'\-\_\.]+$/ && val

                  when tag == "meta" && name == "http-equiv" && val =~ /^Content-Type$/i
                    content = attrs["content"]?
                    content.is_a?(String) && content =~ /^[a-zA-Z\;\-\=\/\ ]+$/ && val

                  when tag == "meta" && name == "name" && val == "keywords"
                    content = attrs["content"]?
                    content.is_a?(String) && content =~ /^[a-zA-Z0-9\,\_\-\ \,\>\<\/]+$/ && val

                  when tag == "meta" && name == "content"
                    val

                  else
                    nil

                  end # == case

        if new_val.is_a?(String)
          attrs[name] = Mu_Clean.escape(new_val)
        else
          return nil
        end
      end

      attrs
    end # === def clean

  end # === module Attr
end # === module Mu_Clean
