RSpec::Matchers.define(:allow_mass_assignment_of) do |*attributes|
  @options = attributes.extract_options!
  @role = @options[:as] || :default
  @attributes = attributes
  @authorizer = nil

  def authorizer(actual)
    @authorizer ||= actual.class.active_authorizer
    @authorizer = @authorizer[@role] if @authorizer.is_a?(Hash)
    @authorizer
  end

  match_for_should do |actual|
    @attributes.all? { |attribute| !authorizer(actual).deny?(attribute) }
  end

  match_for_should_not do |actual|
    @attributes.all? { |attribute| authorizer(actual).deny?(attribute) }
  end

  failure_message_for_should do |actual|
    "Expected #{actual.class.name} to #{description}"
  end

  failure_message_for_should_not do |actual|
    "Did not expect #{actual.class.name} to #{description}"
  end

  description do
    "allow mass-assignment of #{@attributes.to_sentence}"
  end
end
