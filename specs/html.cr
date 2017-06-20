
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
  puts "#{"PASSED".colorize(:green)}: #{filename}"
  # input.should eq(output)
end # === def compare

{% for raw_name in `find specs -maxdepth 1 -mindepth 1 -type d -not -name "tmp"`.split %}
  require "./{{raw_name.gsub(/^specs\//, "").id}}/spec.cr"
{% end %}
