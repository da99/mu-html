
module Homepage
  struct Partial
    include To_Html

    def html
      p :title
      p :msg
      p :msg
    end

  end # === Partial
end # === module Homepage
