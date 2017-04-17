
module Mu_Html

  module Markup

    module DIV
      extend Base
      extend self

      def validate(o : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
        o = validate_attrs o, "div", "class", "body", "childs"
      end

      def_attr "div" do
        delete_if nil
        delete_if :empty_string
        move_if_is_a "body", String
      end

    end # === module DIV

  end # === module Markup

end # === module Mu_Html

