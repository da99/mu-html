
require "../src/mu-html"

class Specs

  {% for raw_name in `find spec -maxdepth 1 -mindepth 1 -type d`.split %}
    {% name = "spec_" + raw_name.split("/").last.gsub(/[^a-zA-Z0-9\_]+/, "_") %}
    def self.{{name.id}}
      Mu_Html.to_html {
        {{ `cat "#{raw_name.id}/input/markup.cr"` }}
      }
    end
    puts self.{{name.id}}
  {% end %}

end # === class Specs


# require "option_parser"

# OPTIONS = {
#   "file" => "none",
#   "output_dir" => "none"
# }

# OptionParser.parse! do |parser|
#   parser.banner = "Usage: mu-html [arguments]"
#   parser.on("--output DIRECTORY", "Directory for saved files.") { |d| OPTIONS["output_dir"] = d }
#   parser.on("--file FILE", "File to process.") { |f| OPTIONS["file"] = f }
# end # === OptionParser

def output_dir
  OPTIONS["output_dir"]
end

def file
  OPTIONS["file"]
end

def write_unless_empty(to : String, content : Hash, key : Symbol)
  return unless content.has_key?(key)
  write_unless_empty(to, content[key])
end

def write_unless_empty(to : String, content : Nil)
  return
end # === def write_unless_empty

def write_unless_empty(to : String, content : String)
  return if content.empty?
  new_path = File.join(output_dir, to)
  puts "=== Writing: #{new_path}"
  File.write(new_path, content)
end # === def write_unless_empty

# =============================================================================

# raise Exception.new("Not a directory: #{output_dir}") unless Dir.exists?(output_dir)
# raise Exception.new("Not a file: #{file}") unless File.file?(file)

# content = Mu_Html.parse(file)

# write_unless_empty("markup.html", content, :html)
# write_unless_empty("style.css",   content, :css)
# write_unless_empty("script.js",   content, :js)






