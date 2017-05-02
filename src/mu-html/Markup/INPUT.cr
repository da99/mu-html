
module Mu_Html

  TAG_OF_INPUT_ALLOWED_TYPES = {"hidden"}
  VALID_NAME                 = /[a-z0-9\_\-]+/
  VALID_VALUE                = /[a-z0-9\_\-\ ]+/

  def_html do
    if node["type"]? == "hidden"
      io << "<input name="
      io << node["name"].inspect
      io << " type=\"hidden\""
      io << " value="
      io << node["value"].inspect
      io << " >"
    end
  end

  def_markup do
    key "input" do
      is_invalid unless value?(A_Data_ID)
      move_to "value"
    end

    key "name" do
      is_invalid unless value?(A_Non_Empty_String)
      is_invalid unless matches?(VALID_NAME)
    end

    key "type" do
      is_invalid unless TAG_OF_INPUT_ALLOWED_TYPES.includes?(value)
    end

    key "value" do
      is_invalid unless value?(A_Data_ID)
      is_invalid unless matches?(VALID_VALUE)
    end
  end

end # === module Mu_Html
