
module Mu_Html

  module Markup

    module P
      extend Base
      extend self

      def validate(o : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
        o = validate_attrs o, "p", "class", "body"
        o = required_attrs o, "body"
        o
      end

      def_attr "p" do
        delete_if nil
        delete_if :empty_string
        move_if_is_a "body", String
      end

    end # === module HTML

  end # === module Markup

end # === module Mu_Html
