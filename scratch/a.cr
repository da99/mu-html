
require "xml"

source = File.read("tmp/source.html")
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
