RSpec::Matchers.define(:allow_values_for) do |*attributes_and_values|
  @attribute = attributes_and_values.shift
  @values = attributes_and_values

  match_for_should do |actual|
    @values.all? do |value|
      subject.stub(@attribute).and_return(value)
      subject.valid?
      subject.errors[@attribute].empty?
    end
  end

  match_for_should_not do |actual|
    @values.none? do |value|
      subject.stub(@attribute).and_return(value)
      subject.valid?
      subject.errors[@attribute].empty?
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
