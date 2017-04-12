
require "./mu-html/*"
require "option_parser"
require "xml"

file = "none"

OptionParser.parse! do |parser|
  parser.banner = "Usage: mu-html [arguments]"
  parser.on("--file FILE", "File to process.") { |f| file = f }
end # === OptionParser

module Mu::Html
end

if !File.file?(file)
  Process.exit(2)
end

source = File.read(file)
document = XML.parse_html(source)
inspect_node(document)

def inspect_node(n)
  n.children.each do |node|
    puts "----------------------------------"
    if node.text?
      puts "\"#{node}\""
    else
      puts "#{node.name} -> #{node.to_s[0,25]}"
      inspect_node(node)
      puts "/#{node.name}"
    end
  end
end


