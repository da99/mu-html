
module Mu_Html
  module Markup
    module DIV

      extend Tag

      def self.tag(parent, o : Hash(String, JSON::Type))

        clean(o) do

          key "div" do
            move_to "body" if value?(A_Non_Empty_String)
            delete if value?(nil) || value?(A_Empty_String)
            is_invalid unless has_key?
          end

          key "class" do
            is_invalid unless value?(A_Class)
          end

          key "body" do
            is_invalid unless value?(A_Data_ID) || value.is_a?(Array)
            to_tags(parent) if value.is_a?(Array)
          end

        end # === clean(o)

      end # === def_tag

    end # === module DIV
  end # === module Markup
end # === module Mu_Html

