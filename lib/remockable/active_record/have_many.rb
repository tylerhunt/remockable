RSpec::Matchers.define(:have_many) do |*association|
  extend Remockable::ActiveRecord::Helpers

  @expected = association.extract_options!
  @association = association.shift

  valid_options %w(class_name foreign_key primary_key dependent counter_cache
    as through source source_type validate autosave inverse_of)

  match do |actual|
    if association = subject.class.reflect_on_association(@association)
      macro_matches = association.macro == :has_many
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
    "have many #{@association}#{with}"
  end
end
