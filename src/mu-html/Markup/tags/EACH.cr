
module Mu_HTML

  VALID_EACH_AS = /^[a-zA-Z0-9\_\-]{1,20}$/
  VALID_EACH_IN = /^[a-zA-Z0-9\_\.\-]{1,20}$/

  # ["each", {"in":"my_data", "as": "i"}, [][][]]
  def_markup do

    attr! "in" do
      is_invalid unless value?(A_Data_ID)
      is_invalid unless value?(A_Non_Empty_String)
      is_invalid unless matches?(VALID_EACH_IN)
    end # === validate_attr "each"

    attr! "as" do
      is_invalid unless value?(A_Non_Empty_String)
      is_invalid unless matches?(VALID_EACH_AS)
    end

    render do

      for_each(attrs["in"]) do |v|
        temp(attrs["as"], v) do
          render(:tail)
        end
      end

    end # === render

  end # === def_markup

end # === module Mu_HTML
