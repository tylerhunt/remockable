RSpec::Matchers.define(:have_index) do
  include Remockable::ActiveRecord::Helpers

  valid_options %w(name unique where)

  def column_names
    @column_names ||= expected_as_array.flatten.collect(&:to_s)
  end

  match do |actual|
    name, unique, where = options.values_at(:name, :unique, :where)
    indexes = ActiveRecord::Base.connection.indexes(subject.class.table_name)

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
      where_matches = where.nil? || index.where == where

      name_matches && unique_matches && where_matches
    end
  end

  def matches_name?(index, name)
    index.name == name.to_s
  end

  failure_message do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_when_negated do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    with = " with #{options.inspect}" if options.any?
    "have index on #{column_names.to_sentence}#{with}"
  end
end
