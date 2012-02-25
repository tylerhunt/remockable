RSpec::Matchers.define(:have_column) do |*column|
  extend Remockable::ActiveRecord::Helpers

  @expected = column.extract_options!
  @column = column.shift

  valid_options %w(default limit null precision scale type)

  match do |actual|
    if column = subject.class.columns.detect { |column| column.name == @column.to_s }
      @expected.all? { |key, value| column.send(key).should == value }
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
    "have column #{@column}#{with}"
  end
end
