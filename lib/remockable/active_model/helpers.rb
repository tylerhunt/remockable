require 'remockable/helpers'

module Remockable
  module ActiveModel
    module Helpers
      include Remockable::Helpers

      CONDITIONALS = [:if, :unless]

      attr_reader :type

      def validator_for(attribute)
        subject.class.validators_on(attribute).detect do |validator|
          validator.kind == type
        end
      end

      def options_match(validator, expected=expected)
        actual = validator.options.slice(*(expected.keys - CONDITIONALS))
        actual == expected.except(*CONDITIONALS)
      end

      def conditionals_match(validator)
        CONDITIONALS.all? do |option|
          expected_value = expected[option]

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
