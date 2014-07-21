RSpec::Matchers.define(:have_and_belong_to_many) do
  include Remockable::ActiveRecord::Helpers

  valid_options %i(
    association_foreign_key
    autosave
    class_name
    foreign_key
    join_table
    validate
  )

  match do |actual|
    if association = subject.class.reflect_on_association(attribute)
      macro_matches = association.macro == :has_and_belongs_to_many
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
    "have and belong to #{attribute}#{with}"
  end
end
