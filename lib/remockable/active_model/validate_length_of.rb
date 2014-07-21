RSpec::Matchers.define(:validate_length_of) do
  include Remockable::ActiveModel::Helpers

  type :length

  unsupported_options %i(tokenizer)

  valid_options %i(
    allow_blank
    allow_nil
    if
    in
    is
    maximum
    message
    minimum
    on
    too_long
    too_short
    unless
    within
    wrong_length
  )

  match do |actual|
    if validator = validator_for(attribute)
      options_match = options_match(validator, normalized_options)
      conditionals_match = conditionals_match(validator)
      options_match && conditionals_match
    end
  end

  def normalized_options
    options.dup.tap do |options|
      if within = options.delete(:within) || options.delete(:in)
        options[:minimum] = within.first
        options[:maximum] = within.last
      end
    end
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
