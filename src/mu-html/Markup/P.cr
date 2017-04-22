
module Mu_Html

  class Markup

    module P

      include Tag::Macro

      def_tag do

        required "p" do
          move_to "body" if is?(Is_Non_Empty_String)
          delete if exists? && is_either?(Is_Empty_String, nil)
          is_invalid if exists?
        end

        attr "class" do
          is_invalid unless is?(REGEX["class"])
        end

        required "body" do
          is_invalid unless is_either?(
            REGEX["data_id"],
            String,
            Array(Hash(String, JSON::Type))
          )
        end

      end # === def_tag

    end # === module P

  end # === class Markup

end # === module Mu_Html
