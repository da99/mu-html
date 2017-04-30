
require "../src/mu-html"
require "option_parser"

OPTIONS = {
  "file" => "none",
  "output_dir" => "none"
}

OptionParser.parse! do |parser|
  parser.banner = "Usage: mu-html [arguments]"
  parser.on("--output DIRECTORY", "Directory for saved files.") { |d| OPTIONS["output_dir"] = d }
  parser.on("--file FILE", "File to process.") { |f| OPTIONS["file"] = f }
end # === OptionParser

def output_dir
  OPTIONS["output_dir"]
end

def file
  OPTIONS["file"]
end

raise Exception.new("Not a directory: #{output_dir}") unless Dir.exists?(output_dir)
raise Exception.new("Not a file: #{file}") unless File.file?(file)

json = Mu_Html.parse(OPTIONS["file"])

if !json
  puts ("Parse error: invalid json")
  Process.exit(2)
end

write_unless_empty("markup.html", Mu_Html::Markup.to_html(json))
write_unless_empty("style.css", Mu_Html::Style.to_css(json))
write_unless_empty("script.js", Mu_Html::Script.to_js(json))

def write_unless_empty(to : String, content : Nil)
  return
end # === def write_unless_empty

def write_unless_empty(to : String, content : String)
  return if content.empty?
  new_path = File.join(output_dir, to)
  puts "=== Writing: #{new_path}"
  File.write(new_path, content)
end # === def write_unless_empty

