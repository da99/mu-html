
module Mu_WWW_HTML

  macro def_markup(name, &block)
    module Markup
      module Clean_Tags
        def tag_of_{{name.id}}
          {{yield}}
          true
        end
      end
    end # === module Markup
  end # === macro def_markup

  macro def_markup(&block)
    {% name = block.filename.split("/").last.split(".cr").first.downcase  %}
    def_markup({{name}}) do
      {{yield}}
    end
  end # === macro def_markup

  module Markup
    module Clean_Tags

      macro in_tag_head!
        return false unless in_head?
      end # === macro in_tag_head!

      macro in_tag_body!
        return false unless in_body?
      end # === macro in_tag_body!

    end # === module Clean_Tags
  end # === module Markup

end # === module Mu_WWW_HTML
