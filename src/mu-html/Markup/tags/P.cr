
module Mu_WWW_HTML

  def_markup do

    tail!

    render(:tag, :attrs) do
      render(:tail)
    end

  end # === def_markup

end # === module Mu_WWW_HTML
