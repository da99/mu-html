
require "./mu-html/*"
require "option_parser"
require "xml"

file = "none"

OptionParser.parse! do |parser|
  parser.banner = "Usage: mu-html [arguments]"
  parser.on("--file FILE", "File to process.") { |f| file = f }
end # === OptionParser

if !File.file?(file)
  Process.exit(2)
end

source = File.read(file)
document = XML.parse_html(source)
Mu_Html.inspect_node(document)

module Mu_Html

  extend self

  def inspect_node(n)
    n.children.each do |node|
      case node
      when .element?
        case node.name
        when "html"
          puts "html tag ====="
          inspect_node(node)
        when "head"
          inspect_node(node)
        when "title"
          puts "title: #{node.children.first.content}"
        when "body"
          inspect_node(node)
        when "p"
          inspect_node(node)
        else
          puts "=== Unknown element: #{node.name}"
        end
      when .text?
        stripped = node.text.strip
        puts "TXT: \"#{stripped}\"" unless stripped.empty?
      when .comment?
        puts "comment: #{node}"
      else
        case
        when node.type.dtd_node?
          puts "#{node.type} #{node}"
          inspect_node(node)
        else
          puts "#{node.type} -> #{node.name} -> #{node.to_s[0,25]}"
          inspect_node(node)
        end
      end # === case
      puts "----------------------------------"
    end # === each
  end # === def

end # === module Mu_Html

