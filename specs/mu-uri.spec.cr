require "../src/mu-uri"

DIR = ARGV.first


IN = File.read(DIR + "/input")
EXPECT = case
         when File.exists?(DIR + "/output")
           File.read(DIR+"/output").rstrip
         when File.exists?(DIR + "/error")
           :error
         when File.exists?(DIR + "/false")
           false
         when File.exists?(DIR + "/true")
           true
         when File.exists?(DIR + "/nil")
           nil
         else
           raise Exception.new("Expected value not found in: #{DIR}")
         end


ACTUAL = Mu_URI.escape(IN) rescue :error
if ACTUAL == EXPECT
  puts "{{PASS}}: #{DIR}"
  exit 0
end


puts "RED{{FAILED}}: #{DIR}"
puts "BOLD{{INPUT}}: #{IN.inspect}"
puts "#{ACTUAL.inspect} RED{{!=}} #{EXPECT.inspect}"
exit 1
