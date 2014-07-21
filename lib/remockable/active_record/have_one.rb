RSpec::Matchers.define(:have_one) do
  include Remockable::ActiveRecord::Helpers

  valid_options %i(
    class_name
    dependent
    foreign_key
    primary_key
    as
    through
    source
    source_type
    validate
    autosave
    inverse_of
  )

  match do |actual|
    if association = subject.class.reflect_on_association(attribute)
      macro_matches = association.macro == :has_one
      options_match = association.options.slice(*options.keys) == options
      macro_matches && options_match
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
    "have a #{attribute}#{with}"
  end
end
