
# data = {
#   "msg1" => "Hello 1",
#   "msg2"=> "Hello 2",
#   "names"=> ["Phil", "Jon", "Dana"],
#   "my_var" => "my var",
#   "TITLE"=> "Hello, Test 00",
#   "copyright"=> "(c)"
# },

# style = {
#   "background"=> "1px red solid",
#   "background-image" => "none",
#   "div p, #id=>first-line" => { "box"=> "4px" },
#   "@media (min-width=> 801px)" => {
#     "body" => {
#       "margin"=> "0 auto",
#       "width"=> "800px"
#     }
#   }
# }


it "works" do
  input = Mu_WWW_HTML.render do
    html do
      head {
        title "TITLE"
      }
      body {
        p "msg1"
        p "msg2"
        div({"class"=>"column"}) {
          span "msg1"
          span "msg2"
          span "my_var"
        }
        each({"in" => "names", "as" => "name"}) {
          p "name"
        }
        footer "copyright"
        input({
          "name"=>"my-hidden",
          "type"=>"hidden",
          "value"=>"msg2"
        })
      }
    end
  end # === Mu_WWW_HTML

output = %[
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Hello, Test 00</title>
  </head>
  <body>
<p>Hello 1</p><p>Hello 2</p><div class="column"><span>Hello 1</span><span>Hello 2</span><span>my var</span></div><p>Phil</p><p>Jon</p><p>Dana</p><footer>&#40;c&#41;</footer><input name="my-hidden" type="hidden" value="msg2" >
  </body>
</html>
]

  input.strip.should eq(output.strip)
end # === it
