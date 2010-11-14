RSpec::Matchers.define(:validate_presence_of) do |*attributes|
  @options = attributes.extract_options! || {}
  @attributes = attributes

  match do |actual|
    @attributes.inject(true) do |result, attribute|
      subject.send(:"#{attribute}=", nil)
      result && !(valid? || empty_errors?(attribute)) && matches_error?(attribute)
    end
  end

  def message(message)
    @options[:message] = message
    self
  end

  def valid? #:nodoc:
    subject.valid?
  end

  def empty_errors?(attribute) #:nodoc:
    subject.errors[attribute].blank?
  end

  def matches_error?(attribute) #:nodoc:
    message = @options[:message] || subject.errors.generate_message(attribute, :blank)
    subject.errors[attribute].include?(message)
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
