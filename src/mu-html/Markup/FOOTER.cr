
module Mu_Html

  class Markup

    module FOOTER

      def_tag do
        required "footer" do
          move_to "body" if is?(Is_Non_Empty_String)
          delete if exists? && is_either?(nil, Is_Empty_String)
          origin["body"] = "" unless origin.has_key?("body")
        end

        required "body" do
          is_invalid unless exists?
        end
      end # === def_tag



    end # === module FOOTER

  end # === class Markup

end # === module Mu_Html
