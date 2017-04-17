
module Mu_Html

  module Markup

    module DIV
      extend self

      ATTRS = {"div", "class", "body", "childs"}

      def standardize(o : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
        Base.standardize("div", o)
      end

    end # === module DIV

  end # === module Markup

end # === module Mu_Html
