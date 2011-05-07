RSpec::Matchers.define(:allow_mass_assignment_of) do |*attributes|
  @attributes = attributes

  match_for_should do |actual|
    @attributes.all? do |attribute|
      !actual.class.active_authorizer.deny?(attribute)
    end
  end

  match_for_should_not do |actual|
    @attributes.all? do |attribute|
      actual.class.active_authorizer.deny?(attribute)
    end
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
