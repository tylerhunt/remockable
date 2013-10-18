RSpec::Matchers.define(:have_scope) do |*name|
  extend Remockable::ActiveRecord::Helpers

  @expected = name.extract_options!
  @name = name.shift
  @relation = nil

  valid_options %w(with)

  match do |actual|
    if subject.class.respond_to?(@name)
      scope = if @expected.key?(:with)
        with = [@expected[:with]] unless @expected[:with].is_a?(Array)
        subject.class.send(@name, *with)
      else
        subject.class.send(@name)
      end

      if scope.is_a?(ActiveRecord::Relation)
        if @relation
          query_matches = scope.arel.to_sql == @relation.arel.to_sql
          eager_load_matches = scope.eager_load_values == @relation.eager_load_values
          includes_matches = scope.includes_values == @relation.includes_values
          lock_matches = scope.lock_value == @relation.lock_value
          preload_matches = scope.preload_values == @relation.preload_values
          readonly_matches = scope.readonly_value == @relation.readonly_value

          query_matches && eager_load_matches && includes_matches && lock_matches && preload_matches && readonly_matches
        else
          true
        end
      end
    end
  end

  def method_missing(method, *args, &block)
    unsupported_query_methods = %(create_with)
    query_methods = %w(eager_load from group having includes joins limit lock offset order preload readonly reorder select where)

    if query_methods.include?(method.to_s)
      @relation ||= subject.class.all
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
    "have scope #{@name}#{with}"
  end
end
