
module A

  NODE = [] of String

  puts self.inspect
end # === module A

macro add_to_a()
  {% A::NODE << "c" %}
end # === macro add_to_a
