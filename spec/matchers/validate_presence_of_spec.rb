require 'spec_helper'

describe "validates_presence_of" do
  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations

      attr_accessor :name, :email

      validates :name, :presence => true
    end
  end

  subject { model.new }

  context "matcher" do
    context "without options" do
      it { should validate_presence_of(:name) }
      it { should_not validate_presence_of(:email) }
    end

    context "with :message option" do
      before(:each) do
        model.validates :name, :presence => { :message => 'is required' }
      end

      it { should validate_presence_of(:name, :message => 'is required') }
      it { should_not validate_presence_of(:name, :message => 'invalid') }
    end
  end

  context "message" do
    context "for a defined validation" do
      let(:matcher) { validate_presence_of(:name) }

      it 'contains a description' do
        matcher.description.should == 'require name to be set'
      end
    end

    context "for an undefined validation" do
      let(:matcher) { validate_presence_of(:email) }

      before(:each) { matcher.matches?(subject) }

      it "sets a custom failure message for should" do
        matcher.failure_message.should ==
          'Expected User to require email to be set'
      end

      it "sets a custom failure message for should not" do
        matcher.negative_failure_message.should ==
          'Did not expect User to require email to be set'
      end
    end
  end
end
