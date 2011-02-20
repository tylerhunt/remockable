module Remockable
  module Helpers
    def unsupported_options(keys)
      @expected.keys.each do |key|
        if keys.collect(&:to_sym).include?(key.to_sym)
          raise ArgumentError.new("Unsupported option #{key.inspect}")
        end
      end
    end

    def valid_options(keys)
      @expected.keys.each do |key|
        unless keys.collect(&:to_sym).include?(key.to_sym)
          raise ArgumentError.new("Unknown option #{key.inspect}")
        end
      end
    end
  end
end
