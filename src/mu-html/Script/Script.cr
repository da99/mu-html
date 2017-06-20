
module Mu_WWW_HTML
  module Script

    def self.clean(json : Hash(String, JSON::Type))
      return json
    end

    def self.to_s(json : Hash(String, JSON::Type), content : Hash(Symbol, String))
      return content
    end # === def self.to_js

  end # === module Script
end # === module Mu_WWW_HTML
