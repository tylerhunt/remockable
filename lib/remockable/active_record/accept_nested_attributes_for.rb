all_blank_proc =
  ActiveRecord::NestedAttributes::ClassMethods::REJECT_ALL_BLANK_PROC

RSpec::Matchers.define(:accept_nested_attributes_for) do
  include Remockable::ActiveRecord::Helpers

  valid_options %w(allow_destroy limit reject_if update_only)

  match do |actual|
    if actual_options = subject.class.nested_attributes_options[attribute]
      options_without_reject_if = options.except(:reject_if)

      reject_if_matches =
        case options[:reject_if]
        when :all_blank
          all_blank_proc == actual_options[:reject_if]
        when Symbol
          options[:reject_if] == actual_options[:reject_if]
        when nil
          true
        else
          raise ArgumentError, 'cannot compare proc values for :reject_if'
        end

      other_options_match =
        actual_options.slice(*options_without_reject_if.keys) ==
          options_without_reject_if

      reject_if_matches && other_options_match
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
