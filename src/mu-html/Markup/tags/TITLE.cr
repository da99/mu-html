
module Mu_HTML
  module Markup
    module Tags

      def head_of_title(meta, val : String)
        is_invalid! unless A_Data_ID.==(val)
        render(:tag, :tail)
      end

    end # === module Tags
  end # === module Markup
end # === module Mu_HTML

  # def_markup do
  #   in_tag_head!
  #   tail! do
  #     single_value!
  #     is_invalid! unless A_Data_ID.==(value)
  #   end
  #   render(:tag, :tail)
  # end # === def_markup

