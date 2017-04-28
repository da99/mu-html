
module Mu_Html
  def_tag do
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
      to_tags
    end
  end
end # === module Mu_Html
