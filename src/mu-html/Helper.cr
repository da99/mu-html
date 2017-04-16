
module Mu_Html

  module Helper

    extend self

    def make_nil_if_empty_string(raw : String)
      str = raw.strip
      str.empty? ? nil : str
    end

    def make_nil_if_empty_string(raw)
      raw
    end

    def read_file(path : String)
      return nil if !path.valid_encoding?
      return nil if !File.file?(path)
      content = File.read(path)
      return nil if !content
      return if !content.valid_encoding?
      content
    rescue Exception
      nil
    end # === def read_file

  end # === module Helper

end # === module Mu_Html
