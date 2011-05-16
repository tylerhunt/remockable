RSpec::Matchers.define(:have_default_scope) do |*expected|
  extend Remockable::ActiveRecord::Helpers

  @expected = expected.extract_options!

  valid_options %w()

  match do |actual|
    if subject.class.respond_to?(:scoped)
      scope = subject.class.scoped

      if scope.is_a?(ActiveRecord::Relation)
        if @relation
          query_matches = scope.arel.to_sql == @relation.arel.to_sql
          eager_load_matches = scope.eager_load_values == @relation.eager_load_values
          includes_matches = scope.includes_values == @relation.includes_values
          lock_matches = scope.lock_value == @relation.lock_value
          preload_matches = scope.preload_values == @relation.preload_values
          readonly_matches = scope.readonly_value == @relation.readonly_value

          query_matches && eager_load_matches && includes_matches && lock_matches && preload_matches && readonly_matches
        elsif subject.class.respond_to?(:default_scoping)
          subject.class.default_scoping.any?
        end
      end
    end
  end

  def method_missing(method, *args, &block)
    unsupposed_query_methods = %(
      create_with
    )

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
    )

    if query_methods.include?(method.to_s)
      @relation ||= subject.class.send(:with_exclusive_scope) do
        subject.class.scoped
      end

      @relation = @relation.send(method, *args)
      self
    else
      super
    end
  end

  failure_message_for_should do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    with = " with #{@expected.inspect}" if @expected.any?
    "have a default scope#{with}"
  end
end
