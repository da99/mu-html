
  data = {
    "msg2"=>     "Hello 2",
    "msg3"=>     "Hello 3",
    "TITLE"=>    "IF Hello",
    "is_true"=>  true,
    "is_false"=> false,
    "window_size"=> 500
  }

html do
  head {
    title "TITLE"
  }
  body {
    if?("is_false") {
      p "msg1"
    }
    if?("is_true") {
      if? "is_true" do
        p "msg2"
      end
    }

    equal?("window_size", 500) do
      p "msg3"
    end
  }
end

