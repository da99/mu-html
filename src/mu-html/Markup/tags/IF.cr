
module Mu_HTML

  def_markup("if?") do

    shift!(:val) do
      is_invalid! unless value?.is_a?(String)
    end # === validate_attr "each"

    tail! do
      is_invalid! unless size > 1
    end

    render do
      render(:tail) if data(:val)
    end

  end # === def_markup

end # === module Mu_HTML
