require "../src/mu-uri"

DIR = ARGV.first

LAST_NEW_LINE = /\n\Z/m
INPUTS = [] of String

def read_file(s : String)
  File.read(s).gsub(LAST_NEW_LINE, "")
end # === def read_file

if File.file?(DIR + "/input")
  INPUTS << read_file(DIR + "/input")
end

if File.file?(DIR + "/multi-input")
  read_file(DIR + "/multi-input").split("\n").each do |line|
    INPUTS << line
  end
end

if File.directory?(DIR + "/input")
  Dir.glob(DIR + "/input/*").each do |file|
    INPUTS << read_file(file)
  end
end

raise Exception.new("No input found.") if INPUTS.empty?

EXPECT = case
         when File.exists?(DIR + "/error")
           :error
         when File.exists?(DIR + "/false")
           false
         when File.exists?(DIR + "/true")
           true
         when File.exists?(DIR + "/nil")
           nil

         when File.exists?(DIR + "/multi-output")
           raw = read_file(DIR+"/multi-output")
           raw.split("\n")

         when File.exists?(DIR + "/output")
           # Check for /output last,
           # other files take precedence if multiple files exist.
           # (e.g. /error, /nil, etc.)
           read_file(DIR+"/output")

         else
           raise Exception.new("Expected value not found in: #{DIR}")

         end # === case


INPUTS.each_index do |i|
  input = INPUTS[i]

  actual = Mu_URI.escape(input) rescue :error

  all_expects = EXPECT
  expect = case all_expects
           when Array
             all_expects[i]
           else
             all_expects
           end

  if actual == expect
    next
  end

  puts "RED{{FAILED}}: #{DIR}"
  puts "BOLD{{INPUT}}: #{input.inspect}"
  puts "#{actual.inspect} RED{{!=}} #{expect.inspect}"
  exit 1

end # == INPUTS.each

if INPUTS.size == 1
  puts "{{PASS}}: #{DIR}"
else
  puts "{{PASS}} (#{INPUTS.size} total): #{DIR}"
end

