require "../src/mu-uri"

DIR = ARGV.first

INPUTS = [] of String

if File.file?(DIR + "/input")
  INPUTS << File.read(DIR + "/input")
end

if File.file?(DIR + "/multi-input")
  File.read(DIR + "/multi-input").split("\n").each do |line|
    INPUTS << line
  end
end

if File.directory?(DIR + "/input")
  Dir.glob(DIR + "/input/*").each do |file|
    INPUTS << File.read(file)
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

         when File.exists?(DIR + "/output")
           # Check for /output last,
           # other files take precedence if multiple files exist.
           # (e.g. /error, /nil, etc.)
           File.read(DIR+"/output").rstrip

         else
           raise Exception.new("Expected value not found in: #{DIR}")

         end # === case


def input_separator
end

INPUTS.each_index do |i|
  input = INPUTS[i]

  actual = Mu_URI.escape(input) rescue :error

  if actual == EXPECT
    next
  end

  puts "RED{{FAILED}}: #{DIR}"
  puts "BOLD{{INPUT}}: #{input.inspect}"
  puts "#{actual.inspect} RED{{!=}} #{EXPECT.inspect}"
  exit 1

end # == INPUTS.each

if INPUTS.size == 1
  puts "{{PASS}}: #{DIR}"
else
  puts "{{PASS}} (#{INPUTS.size} total): #{DIR}"
end

