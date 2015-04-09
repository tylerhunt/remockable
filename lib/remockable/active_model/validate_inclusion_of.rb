RSpec::Matchers.define(:validate_inclusion_of) do
  include Remockable::ActiveModel::Helpers

  type :inclusion

  valid_options %w(allow_nil allow_blank if in message on unless)

  match do |actual|
    validator = validator_for(attribute)
    validator && options_match(validator) && conditionals_match(validator)
  end

  failure_message do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_when_negated do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    with = " with #{options.inspect}" if options.any?
    "validate #{type} of #{attribute}#{with}"
  end
end
