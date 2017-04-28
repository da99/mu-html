
module Mu_Html

  def_tag do
    key "span" do
      move_to "body" if value?(A_Non_Empty_String)
      delete if value?(A_Nothing)
    end

    key? "class" do
      is_invalid unless value?(A_Class)
    end

    key? "body" do
      delete if value?.nil? || value?(A_Empty_String)
      if has_key?
        is_invalid unless value?(A_Data_ID)
      end
    end
  end # === def_tag

end # === module Mu_Html
