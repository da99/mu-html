

macro def_tag(&block)

  def self.validate_tag(o)
    tag = nil
    {{block.body}}
    if !tag.invalid_attributes.empty?
      raise Exception.new("Unknown keys specified: #{tag.invalid_attributes} in tag")
    end
    tag.origin
  end

end # === macro def_tag

macro attr(key)
  key = {{key}}
  tag ||= Markup::Tag.new(key, o)
  tag.attr(key) do
    {{yield}}
  end
end # === macro attr

macro required(key)
  key = {{key}}
  tag ||= Markup::Tag.new(key, o)
  tag.required {{key}} do
    {{yield}}
  end
end




