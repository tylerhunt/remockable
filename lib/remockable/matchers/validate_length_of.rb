RSpec::Matchers.define(:validate_length_of) do |*attributes|
  extend Remockable::Helpers

  @expected = attributes.extract_options!
  @attributes = attributes

  unsupported_options %w(if unless tokenizer)
  valid_options %w(allow_blank allow_nil in is maximum message minimum on
    too_long too_short within wrong_length)

  match do |actual|
    @attributes.inject(true) do |result, attribute|
      validator = subject.class.validators_on(attribute).detect do |validator|
        validator.kind == :length
      end

      expected = @expected.dup

      if within = expected.delete(:within) || expected.delete(:in)
        expected[:minimum] = within.first
        expected[:maximum] = within.last
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
    with = " with #{@expected.inspect}" if @expected.any?
    "validate length of #{@attributes.to_sentence}#{with}"
  end
end
