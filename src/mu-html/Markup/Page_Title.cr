
module Mu_Html

  def_html do
    io << "<title>"
    io << node["body"]
    io << "</title>"
  end # === def_html

  def_markup do
    key("page-title") do
      strip
      is_invalid unless value?(A_Non_Empty_String)
      in_head_tag!
      move_to("body")
      change_tag_to("title")
    end

    key("body") do
    end
  end

end # === module Mu_Html
