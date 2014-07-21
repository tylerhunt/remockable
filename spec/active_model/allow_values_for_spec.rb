require 'spec_helper'

describe :allow_values_for do
  let(:attribute) { :one }
  let(:values) { ['123'] }
  let(:matcher_name) { self.class.parent.description }

  let(:model) {
    build_class :User do
      include ActiveModel::Validations
    end
  }

  subject(:instance) { model.new }

  before do
    model.validates attribute, format: /\A\d+\Z/
  end

  context 'description' do
    it 'has a custom description' do
      matcher = allow_values_for(attribute, *values)

      expect(matcher.description)
        .to eq "allow the values #{values.collect(&:inspect).to_sentence} for #{attribute}"
    end
  end

  context 'failure messages' do
    let(:matcher) { allow_values_for(attribute, *values) }

    before do
      matcher.matches? instance
    end

    it 'has a custom failure message' do
      expect(matcher.failure_message)
        .to eq "Expected #{instance.class.name} to #{matcher.description}"
    end

    it 'has a custom negative failure message' do
      expect(matcher.failure_message_when_negated)
        .to eq "Did not expect #{instance.class.name} to #{matcher.description}"
    end
  end

  it 'matches if the values are valid' do
    should allow_values_for(:one, '123', '4567890')
  end

  it 'does not match if the values are invalid' do
    should_not allow_values_for(:one, 'abc', 'abc123')
  end
end
