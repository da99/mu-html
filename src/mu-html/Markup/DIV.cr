
module Mu_Html

  def_tag do

    key "div" do
      move_to "body" if value?(A_Non_Empty_String)

      if has_key? && (value?(nil) || value?(A_Empty_String))
        delete
      end

      is_invalid if has_key?
    end

    key? "class" do
      is_invalid unless value?(A_Class)
    end

    key "body" do
      is_invalid unless value?(A_Data_ID) || value.is_a?(Array)
      to_tags if value.is_a?(Array)
    end

  end # === def_tag

end # === module Mu_Html

