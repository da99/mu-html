
module Mu_Html
  module Markup

    module A_Empty_String

      def self.==(v)
        v.is_a?(String) && v.strip.empty?
      end

    end # === class Empty_String

    module A_Non_Empty_String

      def self.==(v)
        v.is_a?(String) && !v.strip.empty?
      end

    end # === module A_Non_Empty_String

    module A_Empty_Array

      def self.==(v)
        v.is_a?(Array) && v.empty?
      end

    end # === module A_Empty_Array

    module A_Empty_Hash

      def self.==(v)
        v.is_a?(Hash) && v.empty?
      end

    end # === module A_Empty_Hash

    module A_Nothing

      def self.==(v)
        A_Non_Empty_String.==(v) ||
          A_Empty_Array.==(v) ||
          A_Empty_Hash.==(v) ||
          v.nil?
      end

    end # === module A_Nothing

    module A_Class

      def self.==(v)
        v.is_a?(String) && v =~ REGEX[:class]
      end

    end # === module A_Class

    module A_Data_ID

      def self.==(v)
        v.is_a?(String) && v =~ REGEX[:data_id]
      end

    end # === module A_Data_ID
  end # === module Markup
end # === module Mu_Html

