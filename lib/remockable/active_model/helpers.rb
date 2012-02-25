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
    end
  end
end
