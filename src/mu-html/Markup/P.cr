
module Mu_Html
  module Markup
    module P

      extend Tag

      def self.tag( parent, o )

        clean(o) do

          key( "p") do
            move_to("body") if value?(A_Non_Empty_String)
            delete if value?(A_Nothing)
            is_invalid if has_key?
          end

          key("class") do
            is_invalid unless value?(A_Class)
          end

          key("body") do
            is_invalid unless value?(A_Data_ID) ||
              value?(String) ||
              value?( Array(Hash(String, JSON::Type)) )
          end

        end # === clean_keys

      end # === def self.clean

    end # === module P
  end # === module Markup
end # === module Mu_Html
