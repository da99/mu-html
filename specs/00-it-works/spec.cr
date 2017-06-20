
my_data = {
  "names"=> ["Phil", "Jon", "Dana"],
  "copyright"=> "(c)"
}

style = {
  "background"=> "1px red solid",
  "background-image" => "none",
  "div p, #id=>first-line" => { "box"=> "4px" },
  "@media (min-width=> 801px)" => {
    "body" => {
      "margin"=> "0 auto",
      "width"=> "800px"
    }
  }
}


input = Mu_HTML.render do
  html do
    head {
      meta({"charset"=>"utf-8"})
      title "Hello, Test 00"
    }
    body {
      p "Hello 1"
      p "Hello 2"
      div({"class"=>"column"}) {
        span "Hello 1"
        span "Hello 2"
        span "my var"
      }
      p "Phil"
      p "Jon"
      p "Dana"
      footer "(c)"
      input({
        "name"=>"my-hidden",
        "type"=>"hidden",
        "value"=>"Hello 2"
      })
    }
  end
end # === input

output = %[
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Hello, Test 00</title>
  </head>
  <body>
    <p>Hello 1</p>
    <p>Hello 2</p>
    <div class="column">
      <span>Hello 1</span>
      <span>Hello 2</span>
      <span>my var</span>
    </div>
    <p>Phil</p>
    <p>Jon</p>
    <p>Dana</p>
    <footer>&#40;c&#41;</footer>
    <input name="my-hidden" type="hidden" value="Hello 2">
  </body>
</html>
] # === output


compare(input, output, __FILE__ )

