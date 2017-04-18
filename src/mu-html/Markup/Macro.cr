


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
    k = "{{key.id}}"
    {{block.body}}
    o
  end
end # === macro validate_attr

macro move_if_is_a(new_key, klass)
  move_attr_if_is_a(o, k, {{new_key}}, {{klass}})
end # === macro move_if_is_a

macro delete_if(target)
  delete_attr_if(o, k, {{target}})
end # === macro delete_if

macro move_if(new_key, target)
  move_attr_if(o, k, {{new_key}}, {{target}})
end # === macro move_if

macro required()
  require_attr(o, k)
end # === macro required

macro must_be_a( klass )
  attr_must_be_a(o, k, {{klass}})
end

macro must_match( pattern )
  attr_must_match(o, k, {{pattern}})
end

macro must_be(&block)
  attr_must_be(o, k) {{block}}
end

macro must_be(*conds)
  attr_must_be(o, k, *{{conds}})
end


