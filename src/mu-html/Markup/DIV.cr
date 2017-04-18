
module Mu_Html

  module Markup

    module DIV
      extend Base
      extend self

      def_attr "div" do
        delete_if nil
        delete_if :empty_string
        move_if_is_a "body", String
      end

      def_attr "class" do
        must_match Markup::REGEX["class"]
      end

      def_attr "body" do
        must_be_a Array
      end

    end # === module DIV

  end # === module Markup

end # === module Mu_Html

