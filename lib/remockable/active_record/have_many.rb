RSpec::Matchers.define(:have_many) do
  include Remockable::ActiveRecord::Helpers

  valid_options %i(
    as
    autosave
    class_name
    counter_cache
    dependent
    foreign_key
    inverse_of
    primary_key
    source
    source_type
    through
    validate
  )

  match do |actual|
    if association = subject.class.reflect_on_association(attribute)
      macro_matches = association.macro == :has_many
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
    "have many #{attribute}#{with}"
  end
end
