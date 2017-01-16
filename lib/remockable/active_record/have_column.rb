RSpec::Matchers.define(:have_column) do
  include Remockable::ActiveRecord::Helpers

  valid_options %w(default limit null precision scale type)

  def column
    @column ||= subject.class.columns.detect { |column|
      column.name == attribute.to_s
    }
  end

  match do |actual|
    if column
      options.all? { |key, value|
        if key == :default
          column.send(key) == value.to_s # SQLite3 uses string for default
        else
          column.send(key) == value
        end
      }
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
