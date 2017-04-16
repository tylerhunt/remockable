RSpec::Matchers.define(:have_scope) do |*name|
  include Remockable::ActiveRecord::Helpers

  attr_accessor :relation

  valid_options %w(with)

  match do |actual|
    if subject.class.respond_to?(attribute)
      scope = if options.key?(:with)
        with = [options[:with]] unless options[:with].is_a?(Array)
        subject.class.send(attribute, *with)
      else
        subject.class.send(attribute)
      end

      if scope.is_a?(ActiveRecord::Relation)
        if relation
          query_matches = scope.to_sql == relation.to_sql
          eager_load_matches = scope.eager_load_values == relation.eager_load_values
          includes_matches = scope.includes_values == relation.includes_values
          lock_matches = scope.lock_value == relation.lock_value
          preload_matches = scope.preload_values == relation.preload_values
          readonly_matches = scope.readonly_value == relation.readonly_value

          query_matches && eager_load_matches && includes_matches && lock_matches && preload_matches && readonly_matches
        else
          true
        end
      end
    end
  end

  def method_missing(method, *args, &block)
    query_methods = %w(
      eager_load
      from
      group
      having
      includes
      joins
      limit
      lock
      offset
      order
      preload
      readonly
      reorder
      select
      where
    ).collect(&:to_sym)

    if query_methods.include?(method)
      self.relation ||= subject.class.all
      self.relation = relation.send(method, *args)
      self
    else
      super
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
    "have scope #{attribute}#{with}"
  end
end
