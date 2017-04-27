
module Mu_Html
  module Markup

    module EACH

      extend Tag

      def self.tag(parent, o : Hash(String, JSON::Type))
        clean(o) do
          key "each" do
            is_invalid unless value?(A_Data_ID)
            move_to "in"
          end # === validate_attr "each"

          key "as" do
            is_invalid unless value?(A_Non_Empty_String)
          end

          key "in" do
            is_invalid unless value?(A_Non_Empty_String)
          end

          key "body" do
            is_invalid unless value.is_a?(Array(JSON::Type))
            to_tags(parent)
          end
        end
      end # === def self.tag

    end # === module EACH

  end # === module Markup
end # === module Mu_Html
