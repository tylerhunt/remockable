RSpec::Matchers.define(:validate_presence_of) do |*attributes|
  extend Remockable::Helpers

  @expected = attributes.extract_options!
  @attributes = attributes

  unsupported_options %w(if unless)
  valid_options %w(message on)

  match do |actual|
    @attributes.inject(true) do |result, attribute|
      validator = subject.class.validators_on(attribute).detect do |validator|
        validator.kind == :presence
      end

      validator && validator.options.slice(*expected.keys) == expected
    end
  end

  failure_message_for_should do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    with = " with #{expected.inspect}" if expected.any?
    "validate presence of #{@attributes.to_sentence}#{with}"
  end
end
