require 'spec_helper'

describe :allow_values_for do
  let(:attribute) { :one }
  let(:values) { ['123'] }
  let(:matcher_name) { self.class.parent.description }

  let(:model) do
    build_class(:User) { include ActiveModel::Validations }
  end

  before { model.validates(attribute, :format => /\A\d+\Z/) }

  subject { model.new }

  context 'description' do
    it 'has a custom description' do
      matcher = allow_values_for(attribute, *values)
      matcher.description.should == "allow the values #{values.collect(&:inspect).to_sentence} for #{attribute}"
    end
  end

  context 'failure messages' do
    let(:matcher) { allow_values_for(attribute, *values) }

    before { matcher.matches?(subject) }

    it 'has a custom failure message' do
      matcher.failure_message_for_should.should ==
        "Expected #{subject.class.name} to #{matcher.description}"
    end

    it 'has a custom negative failure message' do
      matcher.failure_message_for_should_not.should ==
        "Did not expect #{subject.class.name} to #{matcher.description}"
    end
  end

  it 'matches if the values are valid' do
    should allow_values_for(:one, '123', '4567890')
  end

  it 'does not match if the values are invalid' do
    should_not allow_values_for(:one, 'abc', 'abc123')
  end
end
