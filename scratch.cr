

require "uri"

uri = URI.parse "http:foo.com" # #time=1305298413"
# => #<URI:0x1003f1e40 @scheme="http", @host="foo.com", @port=nil, @path="/posts", @query="id=30&limit=5", ... >
# puts uri.scheme # => "http"
# puts uri.host   # => "foo.com"
# puts uri.query  # => "id=30&limit=5"
# puts uri.fragment.class

# puts uri.normalize
# puts uri.to_s   # => "http://foo.com/posts?id=30&limit=5#time=1305298413"


def inspect_uri(s)
  uri = URI.parse s
  puts uri.to_s
  {% for id in ["scheme", "host", "path", "query", "fragment"] %}
    puts "{{id.id}}:\t#{uri.{{id.id}}.inspect}"
  {% end %}
  puts uri.normalize.to_s
  puts ""
end

s = "a\nb\nc\n"

# puts s.split(/\n(?!\Z)/m).inspect
# puts URI.unescape("a%74a")
# inspect_uri "h%74tp://example.com"

puts URI.unescape("a+b")
# inspect_uri "javaSCRipt:alert('0');"
# inspect_uri "mailto:alert('0');"
# inspect_uri "http://foo.com/posts?id=30&limit=5" # #time=1305298413"
# inspect_uri "http:foo.com"
# inspect_uri "/foo.com"
# inspect_uri "http:"
# inspect_uri "/"
# inspect_uri "http:///path"
# inspect_uri "mailto:john@mail.com"
# inspect_uri "ftp:example.com"
# inspect_uri "www.my.dot.orh"

