require 'spec_helper'

describe :allow_mass_assignment_of do
  let(:attributes) { :one }
  let(:matcher_name) { self.class.parent.description }

  let(:model) do
    build_class(:User) do
      include ActiveModel::MassAssignmentSecurity
    end
  end

  subject { model.new }

  context 'description' do
    it 'has a custom description' do
      matcher = allow_mass_assignment_of(*attributes)
      attributes = matcher.instance_variable_get(:@attributes).to_sentence
      matcher.description.should == "allow mass-assignment of #{attributes}"
    end
  end

  context 'failure messages' do
    let(:matcher) { allow_mass_assignment_of(*attributes) }

    before(:each) { matcher.matches?(subject) }

    it 'has a custom failure message' do
      matcher.failure_message.should ==
        "Expected #{subject.class.name} to #{matcher.description}"
    end

    it 'sets a custom negative failure message' do
      matcher.negative_failure_message.should ==
        "Did not expect #{subject.class.name} to #{matcher.description}"
    end
  end

  context "for accessible" do
    before(:each) do
      model.attr_accessible(*attributes)
    end

    context "with a single attribute" do
      it 'matches if the attributes are accessible' do
        should allow_mass_assignment_of(:one)
      end

      it "doesn't match if the attributes are protected" do
        should_not allow_mass_assignment_of(:two)
      end
    end

    context "with a role" do
      let(:attributes) { [:one, as: :admin] }

      it 'matches if the attributes are accessible' do
        should allow_mass_assignment_of(:one, as: :admin)
      end

      it "doesn't match if the attributes are protected" do
        should_not allow_mass_assignment_of(:two, as: :admin)
      end
    end

    context "with multiple attributes" do
      let(:attributes) { [:one, :two] }

      it 'matches if the attributes are accessible' do
        should allow_mass_assignment_of(:one, :two)
      end

      it "doesn't match if the attributes are protected" do
        should_not allow_mass_assignment_of(:three)
      end
    end
  end

  context "for protected" do
    before(:each) do
      model.attr_protected(*attributes)
    end

    context "with a single attribute" do
      let(:attributes) { [:three] }

      it 'matches if the attributes are accessible' do
        should allow_mass_assignment_of(:one, :two)
      end

      it "doesn't match if the attributes are protected" do
        should_not allow_mass_assignment_of(:three)
      end
    end

    context "with a role" do
      let(:attributes) { [:three, as: :admin] }

      it 'matches if the attributes are accessible' do
        should allow_mass_assignment_of(:one, as: :admin)
      end

      it "doesn't match if the attributes are protected" do
        should_not allow_mass_assignment_of(:three, as: :admin)
      end
    end

    context "with multiple attributes" do
      let(:attributes) { [:two, :three] }

      it 'matches if the attributes are accessible' do
        should allow_mass_assignment_of(:one)
      end

      it "doesn't match if the attributes are protected" do
        should_not allow_mass_assignment_of(:two, :three)
      end
    end
  end
end
