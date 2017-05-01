
module Mu_Html

  macro def_markup(&block)
    {% name = block.filename.split("/").last.split(".cr").first.downcase  %}
    module Markup
      module Clean_Tags
        def tag_of_{{name.id}}
          {{yield}}
          keys_should_be_known
          tag
        end
      end
    end # === module Markup
  end # === macro def_markup

  macro def_html(&block)
    {% name = block.filename.split("/").last.split(".cr").first.downcase %}
    module Markup
      struct Node
        def to_html_{{name.id}}
          {{yield}}
        end
      end
    end # === module Markup
  end # === macro def_html

end # === module Mu_Html
