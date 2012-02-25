RSpec::Matchers.define(:allow_mass_assignment_of) do |*attribute|
  @options = attribute.extract_options!
  @attribute = attribute.shift

  @role = @options[:as] || :default
  @authorizer = nil

  def authorizer(actual)
    @authorizer ||= actual.class.active_authorizer
    @authorizer = @authorizer[@role] if @authorizer.is_a?(Hash)
    @authorizer
  end

  match_for_should do |actual|
    !authorizer(actual).deny?(@attribute)
  end

  match_for_should_not do |actual|
    authorizer(actual).deny?(@attribute)
  end

  failure_message_for_should do |actual|
    "Expected #{actual.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{actual.class.name} to #{description}"
  end

  description do
    "allow mass-assignment of #{@attribute}"
  end
end
