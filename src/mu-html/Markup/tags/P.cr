
module Mu_Html

  def_markup do

    tail { required }

    render(:tag, :attrs) do
      tail
    end

  end # === def_markup

end # === module Mu_Html
