
module Mu_WWW_Data

    extend self

    VALID_KEY = /^[a-zA-Z0-9\_\-]{1,20}$/
    DATA_ID_INVALID = /[^a-zA-Z0-9\_\-]+/

    def data(json : Hash(String, JSON::Type))
      data = json["data"]?

        case data

      when Hash(String, JSON::Type)
        data.each do |k, v|
          data[key(k)] = value(v)
        end

      when Nil
        json["data"] = {} of String => JSON::Type

      else
        raise Exception.new("section data can only be a key => value structure")

      end
    end # === def parse

    def key(s : String)
      unless s =~ VALID_KEY 
        raise Exception.new("Invalid key in data section: #{s.inspect}")
      end
      s
    end # === def key

    def value(s : String)
      HTML.escape(s)
    end # === def value

    def value(i : Int32 | Int64)
      i
    end

    def value(arr : Array(JSON::Type))
      arr.each_index { |i|
        arr[i] = value(arr[i])
      }
      arr
    end

    def value(h : Hash(String, JSON::Type))
      h.each do |k, v|
        clean_k = key(k)
        raise Exception.new("Invalid key in data: #{k.inspect}") if clean_k != k
        clean_v = value(v)
        case clean_v
        when JSON::Type
          h[clean_k] = clean_v
        else
          raise Exception.new("Invalid value for #{k}: #{v.inspect}")
        end
      end
      h
    end # === def value

    def value(u : Bool)
      u
    end

    def value(u)
      raise Exception.new("Invalid value for data: #{u.inspect}")
      u
    end

    def get(data : Hash(String, JSON::Type), key : String )
      if key =~ DATA_ID_INVALID
        raise Exception.new("Invalid data key: #{key}")
      end
      keys = key.strip.split(".")
      get(get(data), 0, keys)
    end # === def get

    def get(data : Hash(String, JSON::Type), i : Int32, keys : Array(String))
      if i >= keys.size || !data.has_key?(keys[i])
        raise Exception.new("Data not found: #{keys.join(".")}")
      end
      get(data[keys[i]], i+1, keys)
    end # === def get

    def get(data : String | Int64, i : Int32, keys : Array(String))
      HTML.escape(data.to_s)
    end # === def get

    def get(u1, u2, keys : Array(String))
      raise Exception.new("Invalid data value: #{keys.join(".")}")
    end # === def get

    def get(data : JSON::Type, key : JSON::Type)
      case data
      when Hash(String, JSON::Type)
        case key
        when String
          return data[key] if data.has_key?(key)
        end
      end

      raise Exception.new("Data not found: #{key.inspect} in #{data.inspect}")
    end # === def get

    def get_each(data, key)
      v = get(data, key)
      case v
      when Array, Hash
        return v
      end
      raise Exception.new("Invalid data: #{key.inspect} in #{data.inspect}")
    end # === def get_each

    def new_key(data : Hash(String, JSON::Type), key : String, v : String | Int32 | Int64)
      raise Exception.new("Data already exists: #{key.inspect}") if data.has_key?(key)
      data[key] = v
    end # === def new_key

    def new_key(data, key, v)
      raise Exception.new("Invalid retrieval of data: #{data.inspect}, #{key.inspect}, #{v.inspect}")
    end

    def delete(data : Hash(String, JSON::Type), key : String)
      data.delete(key)
    end # === def delete

    def delete(data, key)
      raise Exception.new("Can't delete data: #{data.inspect}, #{key.inspect}")
    end # === def delete

    # === Methods to parse data: =====================
    def parse(path : String)
      source = if File.file?(path)
                 content = File.read(path)
                 raise Exception.new("Empty file.") unless content
                 raise Exception.new("Invalid content encoding.") unless content.valid_encoding?
                 content
               else
                 path
               end

      parse(JSON.parse_raw source)
    end # === def parse

    def parse(json : Hash(String, JSON::Type))
      json.each_key { |k|
        raise Exception.new("Unknown key: #{k}") unless SECTIONS.includes?(k)
      }

      Escape.escape(json)
      DSL.clean(json)

      content = {} of Symbol => String
      DSL.to_s(json, content)

      content
    end # === def parse

    def parse(u)
      raise Exception.new("Invalid json: JSON must be an Object with keys and values..")
    end

end # === module Mu_WWW_Data
