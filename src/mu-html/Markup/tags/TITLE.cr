
module Mu_Html


  def_markup("title") do

    in_tag_head!

    head(0) do
      strip
      is_invalid unless value?(A_Non_Empty_String)
      is_tail
    end

    render(:tag) do
      tail
    end # === render

  end # === def_markup

end # === module Mu_Html
