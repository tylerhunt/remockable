module Remockable
  module Helpers
    attr_reader :type

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

    def validator_for(attribute)
      subject.class.validators_on(attribute).detect do |validator|
        validator.kind == type
      end
    end

    def validate_attributes
      @attributes.inject(true) do |result, attribute|
        yield validator_for(attribute)
      end
    end
  end
end
