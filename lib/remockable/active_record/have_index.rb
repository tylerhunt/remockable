RSpec::Matchers.define(:have_index) do |*attributes|
  extend Remockable::ActiveRecord::Helpers

  @expected = attributes.extract_options!
  @columns = attributes

  valid_options %w(name unique)

  match do |actual|
    name = @expected[:name]
    unique = @expected[:unique]
    indexes = ActiveRecord::Base.connection.indexes(subject.table_name)

    column_names = @columns.flatten.collect(&:to_s)

    index = indexes.detect do |index|
      if column_names.any?
        index.columns == column_names
      elsif name
        matches_name?(index, name)
      end
    end

    if index
      name_matches = name.nil? || matches_name?(index, name)
      unique_matches = unique.nil? || index.unique == unique

      name_matches && unique_matches
    end
  end

  def matches_name?(index, name)
    index.name == name.to_s
  end

  failure_message_for_should do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    with = " with #{expected.inspect}" if expected.any?
    "have index on #{@columns.to_sentence}#{with}"
  end
end
