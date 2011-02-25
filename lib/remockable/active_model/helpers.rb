module Remockable
  module ActiveModel
    module Helpers
      include Remockable::Helpers

      attr_reader :type

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
end
