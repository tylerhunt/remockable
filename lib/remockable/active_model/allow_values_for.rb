RSpec::Matchers.define(:allow_values_for) do |*attributes_and_values|
  @attribute = attributes_and_values.shift
  @values = attributes_and_values

  match_for_should do |actual|
    instance = subject.class.new

    @values.all? do |value|
      instance.stub(@attribute).and_return(value)
      instance.valid?
      instance.errors[@attribute].empty?
    end
  end

  match_for_should_not do |actual|
    instance = subject.class.new

    @values.none? do |value|
      instance.stub(@attribute).and_return(value)
      instance.valid?
      instance.errors[@attribute].empty?
    end
  end

  failure_message_for_should do |actual|
    "Expected #{actual.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{actual.class.name} to #{description}"
  end

  description do
    "allow the values #{@values.collect(&:inspect).to_sentence} for #{@attribute}"
  end
end