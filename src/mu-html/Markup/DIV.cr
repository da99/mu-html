
module Mu_Html

  module Markup

    module DIV

      def_tag do

        attr "div" do
          move_to "body" if is?(Is_Non_Empty_String)
          delete if is_either?(nil, Is_Empty_String)
          should_be !exists?
        end

        attr "class" do
          should_be is?(REGEX["class"])
        end

        attr "body" do
          should_be( is_either?(String, Array) )
        end

      end # === def_tag

    end # === module DIV

  end # === module Markup

end # === module Mu_Html

