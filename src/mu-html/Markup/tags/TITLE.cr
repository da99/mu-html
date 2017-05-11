
module Mu_Html

  def_markup do
    in_tag_head!

    tail! do
      single_value!
      is_invalid! unless A_Data_ID.==(value)
    end

    render(:tag) do
      render(:tail)
    end # === render

  end # === def_markup

end # === module Mu_Html
