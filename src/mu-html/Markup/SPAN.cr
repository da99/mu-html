
module Mu_Html

  class Markup

    module SPAN

      include Tag::Macro

      def_tag do

        required "span" do
          move_to "body" if is?(Is_Non_Empty_String)
          delete if exists? && is_either?(nil, Is_Empty_String)
        end

        attr "class" do
          should_be(REGEX["class"])
        end

        attr "body" do
          delete if is_either?(nil, Is_Empty_String)
          should_be(is?(REGEX["data_id"])) if exists?
        end

      end # === def_tag

    end # === module SPAN

  end # === class Markup

end # === module Mu_Html
