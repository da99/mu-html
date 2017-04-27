
module Mu_Html

  module Markup

    module INPUT

      extend Tag

      ALLOWED_TYPES = {"hidden"}

      def self.tag(parent, o : Hash(String, JSON::Type))
        clean(o) do
          key "input" do
            required
            is_invalid unless value?(A_Data_ID)
            move_to "value"
          end

          key "name" do
            required
            is_invalid unless value?(A_Non_Empty_String)
          end

          key "type" do
            required
            is_invalid unless ALLOWED_TYPES.includes?(value)
          end

          key "value" do
            required
            is_invalid unless value?(A_Data_ID)
          end
        end
      end # === def self.tag


    end # === module INPUT

  end # === module Markup

end # === module Mu_Html
