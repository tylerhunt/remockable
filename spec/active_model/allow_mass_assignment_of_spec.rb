require 'spec_helper'

describe :allow_mass_assignment_of do
  let(:attribute) { :one }
  let(:options) { {} }
  let(:matcher_name) { self.class.parent.description }

  let(:model) do
    build_class(:User) { include ActiveModel::MassAssignmentSecurity }
  end

  subject { model.new }

  context 'description' do
    it 'has a custom description' do
      matcher = allow_mass_assignment_of(attribute)
      matcher.description.should == "allow mass-assignment of #{attribute}"
    end
  end

  context 'failure messages' do
    let(:matcher) { allow_mass_assignment_of(attribute) }

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

  context 'for accessible' do
    before { model.attr_accessible(attribute, options) }

    it 'matches if the attribute is accessible' do
      should allow_mass_assignment_of(:one)
    end

    it 'does not match if the attribute is protected' do
      should_not allow_mass_assignment_of(:two)
    end

    context 'with a role' do
      let(:options) { { :as => :admin } }

      it 'matches if the attribute is accessible' do
        should allow_mass_assignment_of(:one, :as => :admin)
      end

      it 'does not match if the attribute is protected' do
        should_not allow_mass_assignment_of(:two, :as => :admin)
      end
    end
  end

  context 'for protected' do
    let(:attribute) { :two }

    before { model.attr_protected(attribute, options) }

    it 'matches if the attribute is accessible' do
      should allow_mass_assignment_of(:one)
    end

    it 'does not match if the attribute is protected' do
      should_not allow_mass_assignment_of(:two)
    end

    context 'with a role' do
      let(:options) { { :as => :admin } }

      it 'matches if the attribute is accessible' do
        should allow_mass_assignment_of(:one, :as => :admin)
      end

      it 'does not match if the attribute is protected' do
        should_not allow_mass_assignment_of(:two, :as => :admin)
      end
    end
  end
end
