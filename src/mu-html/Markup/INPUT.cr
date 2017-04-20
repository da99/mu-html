
module Mu_Html

  module Markup

    module INPUT

      def_tag do

        required "input" do
          move_to "value" if is?(REGEX["data_id"])
        end

        required "name" do
          is_invalid unless is?(Is_Non_Empty_String)
        end

        required "type" do
          is_invalid unless ["hidden"].includes?(value)
        end

        required "value" do
          is_invalid unless is?(REGEX["data_id"])
        end

      end # === def_tag

    end # === module INPUT

  end # === module Markup

end # === module Mu_Html
