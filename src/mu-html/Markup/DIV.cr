
module Mu_Html

  module Markup

    module DIV

      extend Base
      extend self

      def_attr "div" do
        delete_if Is_Nil
        delete_if Is_Empty_String
        on(Is_String) do
          move_to "body"
        end
        must_be Is_Missing_Key
      end

      def attr_div
        delete_if Is_Nil
        delete_if Is_Empty_String
        on(Is_String) do
          move_to "body"
        end
        must_be Is_Missing_Key
      end

      def_attr "class" do
        must_match REGEX["class"]
      end

      def_attr "body" do
        must_be Is_Array
      end

    end # === module DIV

  end # === module Markup

end # === module Mu_Html

