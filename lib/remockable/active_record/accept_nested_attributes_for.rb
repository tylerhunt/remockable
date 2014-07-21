RSpec::Matchers.define(:accept_nested_attributes_for) do
  include Remockable::ActiveRecord::Helpers

  unsupported_options %i(reject_if)
  valid_options %i(allow_destroy limit update_only)

  match do |actual|
    if actual_options = subject.class.nested_attributes_options[attribute]
      actual_options.slice(*options.keys) == options
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
    "accept nested attributes for #{attribute}#{with}"
  end
end
