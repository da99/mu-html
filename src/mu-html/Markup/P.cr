
module Mu_Html

  module Markup

    module P
      extend Base
      extend self

      def_attr "p" do
        delete_if nil
        delete_if :empty_string
        move_if_is_a "body", String
      end

      def_attr "class" do
        must_match Markup::REGEX["class"]
      end

      def_attr "body" do
        required
      end

    end # === module HTML

  end # === module Markup

end # === module Mu_Html
