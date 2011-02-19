RSpec::Matchers.define(:validate_presence_of) do |*attributes|
  @options = attributes.extract_options!
  @attributes = attributes

  match do |actual|
    @attributes.inject(true) do |result, attribute|
      validator = subject.class.validators_on(attribute).detect do |validator|
        validator.kind == :presence
      end

      validator && validator.options == @options
    end
  end

  def message(message)
    @options[:message] = message
    self
  end

  failure_message_for_should do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    "require #{@attributes.to_sentence} to be set"
  end
end
