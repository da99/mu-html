
module Mu_Html

  TAG_OF_INPUT_ALLOWED_TYPES = {"hidden"}

  def_tag do
    key "input" do
      is_invalid unless value?(A_Data_ID)
      move_to "value"
    end

    key "name" do
      is_invalid unless value?(A_Non_Empty_String)
    end

    key "type" do
      is_invalid unless TAG_OF_INPUT_ALLOWED_TYPES.includes?(value)
    end

    key "value" do
      is_invalid unless value?(A_Data_ID)
    end
  end

end # === module Mu_Html
