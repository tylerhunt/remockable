RSpec::Matchers.define(:allow_values_for) do |*attribute_and_values|
  def values
    expected_as_array[1..-1]
  end

  match do |actual|
    values.all? do |value|
      allow(subject).to receive(attribute).and_return(value)
      subject.valid?
      subject.errors[attribute].empty?
    end
  end

  match_when_negated do |actual|
    values.none? do |value|
      allow(subject).to receive(attribute).and_return(value)
      subject.valid?
      subject.errors[attribute].empty?
    end
  end

  failure_message do |actual|
    "Expected #{actual.class.name} to #{description}"
  end

  failure_message_when_negated do |actual|
    "Did not expect #{actual.class.name} to #{description}"
  end

  description do
    "allow the values #{values.collect(&:inspect).to_sentence} for #{attribute}"
  end
end
