RSpec::Matchers.define(:validate_presence_of) do |attribute, options|
  @attribute = attribute
  @options = options || {}

  match do |actual, options|
    subject.send(:"#{attribute}=", nil)
    !(valid? || empty_errors?) && matches_error?
  end

  def valid?
    subject.valid?
  end

  def empty_errors?
    subject.errors[@attribute].blank?
  end

  def message
    @options[:message] || subject.errors.generate_message(@attribute, :blank)
  end

  def matches_error?
    subject.errors[@attribute].include?(message)
  end

  failure_message_for_should do |actual|
    "Expected #{subject.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{subject.class.name} to #{description}"
  end

  description do
    "require #{attribute} to be set"
  end
end
