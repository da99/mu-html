
module Mu_Html

  def_tag do
    key("page-title") do
      strip
      is_invalid unless value?(A_Non_Empty_String)
    end
  end

end # === module Mu_Html
