RSpec::Matchers.define(:validate_length_of) do |*attribute|
  extend Remockable::ActiveModel::Helpers

  @type = :length
  @expected = attribute.extract_options!
  @attribute = attribute.shift

  unsupported_options %w(tokenizer)
  valid_options %w(allow_blank allow_nil if in is maximum message minimum on
    too_long too_short unless within wrong_length)

  match do |actual|
    if validator = validator_for(@attribute)
      options_match = options_match(validator, normalized_expected)
      conditionals_match = conditionals_match(validator)
      options_match && conditionals_match
    end
  end

  def normalized_expected
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
    "validate #{type} of #{@attribute}#{with}"
  end
end
