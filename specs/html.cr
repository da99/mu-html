
require "colorize"

def strip(str : String)
  io = IO::Memory.new
  str.strip.each_line { |s|
    io << s.strip
  }
  io.to_s
end # === def strip

def compare(raw_input, raw_output, filename)
  input  = strip(raw_input)
  output = strip(raw_output)
  if input != output
    puts("Failed: ".colorize.mode(:bold).to_s + " " + filename.colorize(:red).to_s)
    puts raw_input
    puts ""
    puts raw_output

    puts ""
    puts input.colorize(:red)
    puts output.colorize(:yellow)
    exit 1
  end

  it filename do
    input.should eq(output)
  end
end # === def compare

require "./html/*"

