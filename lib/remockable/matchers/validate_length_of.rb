RSpec::Matchers.define(:validate_length_of) do |*attributes|
  extend Remockable::Helpers

  @type = :length
  @expected = attributes.extract_options!
  @attributes = attributes

  unsupported_options %w(if unless tokenizer)
  valid_options %w(allow_blank allow_nil in is maximum message minimum on
    too_long too_short within wrong_length)

  match do |actual|
    validate_attributes do |validator|
      expected = normalize_expected
      validator && validator.options.slice(*expected.keys) == expected
    end
  end

  def normalize_expected
    expected.dup.tap do |expected|
      if within = expected.delete(:within) || expected.delete(:in)
        expected[:minimum] = within.first
        expected[:maximum] = within.last
      end
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
    "validate #{type} of #{@attributes.to_sentence}#{with}"
  end
end
