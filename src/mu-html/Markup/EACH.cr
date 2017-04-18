
module Mu_Html

  module Markup

    module EACH

      extend Base
      extend self

      def_attr "each" do
        must_be(REGEX["data_id"])
        move_to "in"
      end # === validate_attr "each"

      def_attr "as" do
        must_be(String, :"!empty")
        required
      end

      def_attr "in" do
        must_be(String, :"!empty")
        required
      end

      def_attr "body" do
        must_be_a Array(JSON::Type)
        required
      end

    end # === module EACH

  end # === module Markup

end # === module Mu_Html
