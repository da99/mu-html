
describe %[Mu_WWW_Attr.clean "input", "name")] do

  it "returns nil if value has invalid characters" do
    Mu_WWW_Attr.clean("input", {"name"=>"$#%#%"}).should eq(nil)
  end

end # === describe

describe %[Mu_WWW_Attr.clean "input", "value"] do

  it "allows spaces" do
    val = " my val "
    Mu_WWW_Attr.clean("input", {"value" => val}).should eq({"value"=>val})
  end

  it "returns nil if tag name is not \"input\"" do
    Mu_WWW_Attr.clean("inputs", {"value"=>" hidden "}).should eq(nil)
  end

end # === describe

describe %[Mu_WWW_Attr.clean "input" {"type"=>"hidden"}] do

  it "returns the same value" do
    Mu_WWW_Attr.clean("input", {"name"=>"hidden"}).should eq({"name"=>"hidden"})
  end

  it "returns nil if value is not \"hidden\"" do
    Mu_WWW_Attr.clean("input", {"name"=>" hidden "}).should eq(nil)
  end

end # === describe

describe %[ Mu_WWW_Attr.clean tag_name, {"class"=>val} ] do

  it "allows spaces" do
    val = " my class "
    Mu_WWW_Attr.clean("div", {"class"=>val}).should eq({"class"=>val})
  end

end # === describe

describe %[ Mu_WWW_Attr.clean("a", {"href"=>val} ] do

  it "returns nil if value is an invalid uri" do
    Mu_WWW_Attr.clean("a", {"href"=>"javascript://alert()"}).should eq(nil)
  end

  it "returns value if value is a valid uri" do
    Mu_WWW_Attr.clean("a", {"href"=>"/home/home/home"}).should eq({"href"=>"/home/home/home"})
  end

end # === describe

describe %[ Mu_WWW_Attr.clean("form", "action", val) ] do
  it "returns nil if value is an invalid uri" do
    Mu_WWW_Attr.clean("form", {"action"=>"javascript://alert()"}).should eq(nil)
  end

  it "returns nil if value is not a path" do
    Mu_WWW_Attr.clean("form", {"action"=>"http://my.uri/"}).should eq(nil)
  end

  it "allows a value of a relative path" do
    Mu_WWW_Attr.clean("form", {"action"=>"/my.uri/"}).should eq({"action"=>"/my.uri/"})
  end
end # === describe

describe %[ Mu_WWW_Attr.clean("meta", {"keywords"=>" <a> "}) ] do

  it "HTML escapes values" do
    Mu_WWW_Attr.clean("meta", {"name"=>"keywords", "content"=>" <a> "}).should eq({"name"=>"keywords", "content"=>" &lt;a&gt; "})
  end

end # === describe

describe %[ Mu_WWW_Attr.clean("meta", {"charset"=>"utf-8"}) ] do
  it "allows charset" do
    Mu_WWW_Attr.clean("meta", {"charset"=>"utf-8"}).should eq({"charset"=>"utf-8"})
  end
end # === describe
