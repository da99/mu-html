
module Mu_Html

  def_markup("if?") do

    head! do
      is_invalid unless value?.is_a?(String)
    end # === validate_attr "each"

    tail! do
      is_invalid unless size > 1
    end

    render do
      render(:tail) if get(head)
    end

  end # === def_markup

end # === module Mu_Html
