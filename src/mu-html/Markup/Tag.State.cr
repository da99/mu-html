
module Mu_Html
  module Markup
    module Tag
      struct State

        def initialize(@tag_name : String, @parent : Key::State | Markup::State, @origin : Hash(String, JSON::Type))
          @keys = ["tag"] of String
          raise Exception.new("Invalid tag: #{@tag_name}: tag") if @origin.has_key?("tag")
          @origin["tag"] = @tag_name
        end # === def initialize

        def tag
          @origin
        end

        def key(k : String)
          @keys << k

          state = Key::State.new(@tag_name, @origin, k)
          with state yield(state)

          @origin
        end # === def key

        def key?(k : String)
          @keys << k
          return @origin unless @origin.has_key?(k)

          key(k) do |state|
            with state yield
          end

          @origin
        end

        def keys_should_be_known
          @origin.each_key do |k|
            Key::State.new(@tag_name, @origin, k).is_invalid unless @keys.includes?(k)
          end
        end # === def keys_should_be_known

      end # === struct State
    end # === module Tag
  end # === module Markup
end # === module Mu_Html
