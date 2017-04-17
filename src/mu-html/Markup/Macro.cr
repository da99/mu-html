


# module Mu_Html
# end # === module Mu_Html

macro validate_attrs(o, *keys)

  begin
    valid_keys = {{keys}}
    {{o}} = allowed_attrs {{o}}, *{{keys}}
    {% for k in keys %}
      if {{o}}.has_key?({{k}})
        {{o}} = tag_attr_{{k.id}}({{o}})
      end
    {% end %}
    o
  end
end # === macro validate

macro def_attr(key, &block)
  def tag_attr_{{key.id}}(o : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
    key = "{{key.id}}"
    {{block.body}}
    o
  end
end # === macro validate_attr

macro move_if_is_a(new_key, klass)
  move_attr_if_is_a(o, key, {{new_key}}, {{klass}})
end # === macro move_if_is_a

macro delete_if(target)
  begin
    if o.has_key?(key)
      if o[key] == {{target}}
        o.delete(key)
      end
    end
    o
  end
end # === macro delete_if

macro move_if(new_key, target)
  begin
    if o.has_key?(key)
      if o[key] == {{target}}
        if o.has_key?({{new_key}})
          raise Exception.new("{{new_key.id}} attribute has been set twice in #{tag_name}: #{key}, {{new_key.id}}")
        end
        o[{{new_key}}] = o[key]
        o.delete(key)
      end
    end
    o
  end
end # === macro move_if

macro required_attrs(o, *keys)
  begin
    required_keys = {{keys}}
    {% for k in keys %}
      raise Exception.new("Missing key in #{tag_name}: {{k.id}}") unless {{o}}.has_key?({{k}})
    {% end %}
    o
  end
end # === macro required

