
module Mu_Html

  def_markup("if?") do

    head(0) do
      is_invalid unless value?.is_a?(String)
      attr("if_data")
    end # === validate_attr "each"

    tail do
      is_invalid unless size > 1
    end

    render do
      if get(attr("if_data"))
        tail
      end
    end

  end # === def_markup

end # === module Mu_Html
