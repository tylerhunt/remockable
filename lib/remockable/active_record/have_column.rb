RSpec::Matchers.define(:have_column) do
  include Remockable::ActiveRecord::Helpers

  valid_options %i(default limit null precision scale type)

  def column
    @column ||= subject.class.columns.detect { |column|
      column.name == attribute.to_s
    }
  end

  match do |actual|
    if column
      options.all? { |key, value| column.send(key) == value }
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
    "have column #{attribute}#{with}"
  end
end
