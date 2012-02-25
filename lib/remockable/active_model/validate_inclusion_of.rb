RSpec::Matchers.define(:validate_inclusion_of) do |*attribute|
  extend Remockable::ActiveModel::Helpers

  @type = :inclusion
  @expected = attribute.extract_options!
  @attribute = attribute.shift

  unsupported_options %w(if unless)
  valid_options %w(allow_nil allow_blank in message on)

  match do |actual|
    validator = validator_for(@attribute)
    validator && validator.options.slice(*expected.keys) == expected
  end

  failure_message_for_should do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    with = " with #{expected.inspect}" if expected.any?
    "validate #{type} of #{@attribute}#{with}"
  end
end
