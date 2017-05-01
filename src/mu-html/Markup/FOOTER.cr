
module Mu_Html
  def_markup do
    key "footer" do
      move_to "body" if value?(A_Non_Empty_String)
      delete if has_key? && value?(nil) || value?(A_Empty_String)
      origin["body"] = "" unless origin.has_key?("body")
    end

    key "body" do
      is_invalid unless has_key?
      case value
      when Array
        to_tags
      when String
        :ignore
      else
        is_invalid
      end
    end
  end
end # === module Mu_Html
