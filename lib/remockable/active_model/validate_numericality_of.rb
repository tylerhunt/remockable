RSpec::Matchers.define(:validate_numericality_of) do
  include Remockable::ActiveModel::Helpers

  type :numericality

  valid_options %i(
    allow_nil
    equal_to
    even
    greater_than
    greater_than_or_equal_to
    if
    less_than
    less_than_or_equal_to
    message
    odd
    on
    only_integer
    unless
  )

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
