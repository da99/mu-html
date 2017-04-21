
module Mu_Html

  class Markup

    module INPUT

      ALLOWED_TYPES = {"hidden"}

      def_tag do

        required "input" do
          is_invalid unless is?(REGEX["data_id"])
          move_to "value"
        end

        required "name" do
          is_invalid unless is?(Is_Non_Empty_String)
        end

        required "type" do
          is_invalid unless ALLOWED_TYPES.includes?(value)
        end

        required "value" do
          is_invalid unless is?(REGEX["data_id"])
        end

      end # === def_tag

    end # === module INPUT

  end # === class Markup

end # === module Mu_Html
