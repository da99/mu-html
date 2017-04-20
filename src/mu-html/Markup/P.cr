
module Mu_Html

  module Markup

    module P

      def_tag do

        attr "p" do
          move_to "body" if is?(Is_Non_Empty_String)
          delete if exists? and is_either?(Is_Empty_String, nil)
          is_invalid if exists?
        end

        attr "class" do
          is_invalid unless is?(Markup::REGEX["class"])
        end

        required "body" do
          is_invalid unless is_either?(
            Markup::REGEX["data_id"],
            String,
            Array(Hash(String, JSON::Type))
          )
        end

      end # === def_tag

    end # === module P

  end # === module Markup

end # === module Mu_Html
