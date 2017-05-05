
module Mu_Html

  def_html do

    Data.get_each(data, node["in"]).each do |v|
      Data.new_key(data, node["as"], v)
      string_or_tags
      Data.delete(data, node["as"])
    end

  end # === def_html

  VALID_EACH_AS = /^[a-zA-Z0-9\_\-]{1,20}$/
  VALID_EACH_IN = /^[a-zA-Z0-9\_\.\-]{1,20}$/
  def_markup do

    key "each" do
      is_invalid unless value?(A_Data_ID)
      move_to "in"
    end # === validate_attr "each"

    key "as" do
      is_invalid unless value?(A_Non_Empty_String)
      is_invalid unless matches?(VALID_EACH_AS)
    end

    key "in" do
      is_invalid unless value?(A_Non_Empty_String)
      is_invalid unless matches?(VALID_EACH_IN)
    end

    key "body" do
      is_invalid unless value.is_a?(Array(JSON::Type))
      to_tags
    end
  end # === def_markup

end # === module Mu_Html
