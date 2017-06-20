
module Mu_WWW_HTML

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

  end # === module Base

end # === module Mu_WWW_HTML
