
module Mu_WWW_HTML

  TAG_OF_INPUT_ALLOWED_TYPES = {"hidden"}
  VALID_NAME                 = /[a-z0-9\_\-]+/
  VALID_VALUE                = /[a-z0-9\_\-\ ]+/

  def_markup do

    attr! "name" do
      is_invalid unless value?(A_Non_Empty_String)
      is_invalid unless matches?(VALID_NAME)
    end

    attr! "type" do
      is_invalid unless TAG_OF_INPUT_ALLOWED_TYPES.includes?(value)
    end

    attr! "value" do
      is_invalid unless value?(A_Data_ID)
      is_invalid unless matches?(VALID_VALUE)
    end

    render(:tag, :attrs)

  end # === def_markup

end # === module Mu_WWW_HTML
