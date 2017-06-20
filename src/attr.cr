
module Mu_WWW_Attr

  extend self

  def self.invalid(tag_name, name, val)
    raise Exception.new("Invalid attribute: #{tag_name.inspect}.#{name.inspect} = #{val.inspect}")
  end # === def invalid_attr

  def clean(tag, attrs : Hash(String, String))
    attrs.keys.each do |name|
      val  = attrs[name]
      return nil if !val

      new_val = case

                when tag == "html" && name == "lang"
                  val =~ /^[a-z0-9\-\_]+$/ && val

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
                  Mu_WWW_URI.clean(val)

                when tag == "script" && name == "async"
                  (val =~ /true|false/i) && val

                when tag == "script" && name == "src"
                  val =~ /^[a-z0-9\_\.\/]+$/i && val

                when name == "class"
                  val.is_a?(String) && val =~ /^[a-zA-Z0-9\_\ ]+$/ && val

                when tag == "link" && name == "href"
                  val =~ /^\/[a-zA-Z\.0-9\-\_\/]+$/ && Mu_WWW_URI.clean(val)

                when tag == "link" && name == "rel"
                  val =~ /^[a-zA-Z0-9\ ]+$/ && val

                when tag == "link" && name == "title"
                  val =~ /^[a-zA-Z0-9\ \_\-\.]+$/ && val

                when tag == "link" && name == "type" && val =~ /^text\/css;?$/i
                  val

                when tag == "link" && name == "media" && val =~ /^[\(\)\-\:\ a-zA-Z0-9]+$/

                when tag == "a" && name == "href"
                  Mu_WWW_URI.clean(val)

                when tag == "form" && name == "action"
                  val =~ /^\/[a-zA-Z0-9\.\_\-\/]+$/ && Mu_WWW_URI.clean(val)

                when tag == "meta" && name == "charset"
                  val =~ /^[a-z\-0-9]+$/ && val

                # For security reasons, "refresh" is left out.
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
        attrs[name] = Mu_WWW_HTML.escape(new_val)
      else
        return nil
      end
    end

    attrs
  end # === def clean

end # === module Mu_WWW_Attr
