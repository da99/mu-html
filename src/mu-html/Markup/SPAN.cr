
module Mu_Html
  module Markup
    module SPAN

      extend Tag

      def self.tag(parent, o : Hash(String, JSON::Type))

        clean(o) do
          key "span" do
            required
            move_to "body" if value?(A_Non_Empty_String)
            delete if has_key? && value?.nil? && value?(A_Empty_String)
          end

          key "class" do
            is_invalid unless value?(A_Class)
          end

          key "body" do
            delete if value?.nil? || value?(A_Empty_String)
            if has_key?
              is_invalid unless value?(A_Data_ID)
            end
          end
        end

      end # === def self.tag

    end # === module SPAN
  end # === module Markup
end # === module Mu_Html
