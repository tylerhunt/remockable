RSpec::Matchers.define(:validate_length_of) do |*attribute|
  extend Remockable::ActiveModel::Helpers

  @type = :length
  @expected = attribute.extract_options!
  @attribute = attribute.shift

  unsupported_options %w(if unless tokenizer)
  valid_options %w(allow_blank allow_nil in is maximum message minimum on
    too_long too_short within wrong_length)

  match do |actual|
    expected = normalize_expected
    validator = validator_for(@attribute)
    validator && validator.options.slice(*expected.keys) == expected
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
    "validate #{type} of #{@attribute}#{with}"
  end
end
