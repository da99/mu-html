
module Mu_Html

  module Markup

    module P
      extend self

      ATTRS = {"p", "class", "body"}

      def standardize(o : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
        tag = Base.standardize("p", o)
        Base.require_value "p", tag, "body", {String}
        tag
      end

    end # === module HTML

  end # === module Markup

end # === module Mu_Html
