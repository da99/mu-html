
describe %[Mu_Clean.attr("input", "name", val)] do

  it "returns nil if value has invalid characters" do
    Mu_Clean.attr("input", "name", "$#%#%").should eq(nil)
  end

end # === describe

describe %[Mu_Clean.attr("input", "value", val)] do

  it "allows spaces" do
    val = " my val "
    Mu_Clean.attr("input", "value", val).should eq(val)
  end

  it "returns nil if tag name is not \"input\"" do
    Mu_Clean.attr("inputs", "value", " hidden ").should eq(nil)
  end

end # === describe

describe %[Mu_Clean.attr("input", "type", "hidden")] do

  it "returns the same value" do
    Mu_Clean.attr("input", "name", "hidden").should eq("hidden")
  end

  it "returns nil if value is not \"hidden\"" do
    Mu_Clean.attr("input", "name", " hidden ").should eq(nil)
  end

end # === describe

describe "Mu_Clean.attr(tag_name, \"class\", val)" do

  it "allows spaces" do
    val = " my class "
    Mu_Clean.attr("div", "class", val).should eq(val)
  end

end # === describe

describe "Mu_Clean.attr(\"a\", \"href\", val)" do

  it "returns nil if value is an invalid uri" do
    Mu_Clean.attr("a", "href", "javascript://alert()").should eq(nil)
  end

  it "returns value if value is a valid uri" do
    Mu_Clean.attr("a", "href", "/home/home/home").should eq("/home/home/home")
  end

end # === describe

describe %[ Mu_Clean.attr("form", "action", val) ] do
  it "returns nil if value is an invalid uri" do
    Mu_Clean.attr("form", "action", "javascript://alert()").should eq(nil)
  end

  it "returns nil if value is not a path" do
    Mu_Clean.attr("form", "action", "http://my.uri/").should eq(nil)
  end

  it "allows a value of a relative path" do
    Mu_Clean.attr("form", "action", "/my.uri/").should eq("/my.uri/")
  end
end # === describe
