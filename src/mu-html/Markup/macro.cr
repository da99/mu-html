

macro def_tag(&block)

  def self.validate_tag(o)
    attributes = [] of String
    tag = nil
    {{block.body}}
    invalid_attributes = o.keys - attributes
    if !invalid_attributes.empty?
      raise Exception.new("Unknown keys specified: #{invalid_attributes} in tag")
    end
    tag.origin
  end

end # === macro def_tag

macro attr(key)
  key = {{key}}
  tag ||= Markup::Tag.new(key, o)
  attributes << key
  tag.attr(key) do
    {{yield}}
  end
end # === macro attr

macro required(key)
  attr {{key}} do
    {{yield}}
  end
  tag.required
end




