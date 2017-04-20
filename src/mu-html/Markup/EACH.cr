
module Mu_Html

  module Markup

    module EACH

      def_tag do

        required "each" do
          should_be is?(REGEX["data_id"])
          move_to "in"
        end # === validate_attr "each"

        required "as" do
          should_be is?(Is_Non_Empty_String)
        end

        required "in" do
          should_be is?(Is_Non_Empty_String)
        end

        required "body" do
          should_be is?(Array(JSON::Type))
        end

      end # == def_tag

    end # === module EACH

  end # === module Markup

end # === module Mu_Html
