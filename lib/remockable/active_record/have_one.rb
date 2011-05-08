RSpec::Matchers.define(:have_one) do |*attributes|
  extend Remockable::ActiveRecord::Helpers

  @expected = attributes.extract_options!
  @association = attributes.first

  unsupported_options %w(extend)
  valid_options %w(class_name conditions order dependent foreign_key primary_key include as select through source source_type readonly validate autosave inverse_of)

  match do |actual|
    if association = subject.class.reflect_on_association(@association)
      macro_matches = association.macro.should == :has_one
      options_match = association.options.slice(*expected.keys) == expected
      macro_matches && options_match
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
    "have a #{@association}#{with}"
  end
end
