
module Mu_Html

  module Data

    def self.parse(json : Hash(String, JSON::Type) )
    data = json.has_key?("data") ? json["data"] : nil
    case json["data"]
    when Hash
      json["data"]
    when Nil
      {} of String => JSON::Type
    else
      raise Exception.new("section data can only be a key => value structure")
    end
    end # === def self.parse

  end # === module Data

end # === module Mu_Html
