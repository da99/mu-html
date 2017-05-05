
module Mu_Html

  def_html do

    cond = Data.get(data, node["if"])
    if cond
      string_or_tags
    end

  end # === def_html

  def_markup do

    key "if" do
      is_invalid unless value?(A_Data_ID)
    end # === validate_attr "each"

    key "body" do
      is_invalid unless value.is_a?(Array(JSON::Type))
      to_tags
    end
  end # === def_markup

end # === module Mu_Html
