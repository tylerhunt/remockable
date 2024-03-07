RSpec::Matchers.define(:allow_values_for) do
  include Remockable::ActiveModel::Helpers

  match do |actual|
    values.all? do |value|
      assign_value attribute, value
      subject.valid?
      subject.errors[attribute].empty?
    end
  end

  match_when_negated do |actual|
    values.none? do |value|
      assign_value attribute, value
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

  def assign_value(attribute, value)
    if subject.respond_to?(:"#{attribute}=")
      subject.send(:"#{attribute}=", value)
    else
      allow(subject).to receive(attribute).and_return(value)
    end
  end

  def values
    expected_as_array[1..-1]
  end
end
