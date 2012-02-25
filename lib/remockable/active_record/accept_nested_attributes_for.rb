RSpec::Matchers.define(:accept_nested_attributes_for) do |*association|
  extend Remockable::ActiveRecord::Helpers

  @expected = association.extract_options!
  @association = association.shift

  unsupported_options %w(reject_if)
  valid_options %w(allow_destroy limit update_only)

  match do |actual|
    if options = subject.class.nested_attributes_options[@association]
      options.slice(*expected.keys) == expected
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
    "accept nested attributes for #{@association}#{with}"
  end
end
