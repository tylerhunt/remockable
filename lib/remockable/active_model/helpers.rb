require 'active_support/concern'

require 'remockable/helpers'

module Remockable
  module ActiveModel
    module Helpers
      extend ActiveSupport::Concern
      include Remockable::Helpers

      CONDITIONALS = [:if, :unless]

      def validator_for(attribute)
        subject.class.validators_on(attribute).detect do |validator|
          validator.kind == type
        end
      end

      def options_match(validator, options=self.options)
        actual = validator.options.slice(*(options.keys - CONDITIONALS))
        actual == options.except(*CONDITIONALS)
      end

      def conditionals_match(validator)
        CONDITIONALS.all? do |option|
          expected_value = options[option]

          if !expected_value.nil? && expected_value.is_a?(Symbol)
            validator.options[option] == expected_value
          elsif !expected_value.nil?
            validator.options[option].call(actual) == true
          else
            true
          end
        end
      end
    end
  end
end
