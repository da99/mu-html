
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

  end # === module Attr
end # === module Mu_Clean
