
module Mu_Html
  module Markup
    module FOOTER

      extend Tag

      def self.tag(parent, o : Hash(String, JSON::Type))
        clean(o) do
          key "footer" do
            required
            move_to "body" if value?(A_Non_Empty_String)
            delete if has_key? && value?(nil) || value?(A_Empty_String)
            origin["body"] = "" unless origin.has_key?("body")
          end

          key "body" do
            required
            is_invalid unless has_key?
          end
        end
      end # === def self.tag

    end # === module FOOTER
  end # === module Markup
end # === module Mu_Html
