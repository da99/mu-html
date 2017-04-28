
module Mu_Html
  def_tag do

    key("p") do
      move_to("body") if value?(A_Non_Empty_String)
      delete if has_key? && value?(A_Nothing)
      is_invalid if has_key?
    end

    key?("class") do
      is_invalid unless value?(A_Class)
    end

    key("body") do
      is_invalid unless value?(A_Data_ID) ||
        value?(String) ||
        value?( Array(Hash(String, JSON::Type)) )
      to_tags if value?.is_a?(Array)
    end

  end # === clean_keys
end # === module Mu_Html
