
module Mu_Html

  def_markup do
    key("page-title") do
      strip
      is_invalid unless value?(A_Non_Empty_String)
      page_title(value)
      delete
    end
  end

end # === module Mu_Html
