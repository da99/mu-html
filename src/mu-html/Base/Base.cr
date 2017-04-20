
require "./Validate"
module Mu_Html

  module Base

    extend self

    def allowed_keys(allowed, o)
      o.keys.each do |k|
        raise Exception.new("Invalid key: #{k}") unless allowed.includes?(k)
      end
      true
    end

    def allowed_keys(name : String, allowed, o)
      o.keys.each do |k|
        raise Exception.new("Invalid key in #{name}: #{k}") unless allowed.includes?(k)
      end
      true
    end

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
    end # === def read_file

  end # === module Base

end # === module Mu_Html
