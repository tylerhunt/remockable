require 'spec_helper'

describe "validates_confirmation_of" do
  let(:attributes) { :email }
  let(:options) { true }

  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations

      attr_accessor :email, :password
    end
  end

  before(:each) do
    model.validates(*attributes, :confirmation => options)
  end

  subject { model.new }

  context "matcher" do
    context "with a single attribute" do
      it { should validate_confirmation_of(:email) }
      it { should_not validate_confirmation_of(:password) }
    end

    context "with multiple attributes" do
      let(:attributes) { [:email, :password] }

      it { should validate_confirmation_of(:email, :password) }
    end

    context "with option :message" do
      let(:options) { { :message => 'must match!' } }

      it { should validate_confirmation_of(:email, :message => 'must match!') }
      it { should_not validate_confirmation_of(:email, :message => 'invalid') }
    end

    context "with option :on" do
      let(:options) { { :on => :create } }

      it { should validate_confirmation_of(:email, :on => :create) }
      it { should_not validate_confirmation_of(:email, :on => :update) }
    end

    context "with unsupported option :if" do
      it "raises an error" do
        expect {
          validate_confirmation_of(:email, :if => :allow_validation)
        }.to raise_error(ArgumentError, /unsupported.*:if/i)
      end
    end

    context "with unsupported option :unless" do
      it "raises an error" do
        expect {
          validate_confirmation_of(:email, :unless => :allow_validation)
        }.to raise_error(ArgumentError, /unsupported.*:unless/i)
      end
    end

    context "with an unknown option" do
      it "raises an error" do
        expect {
          validate_confirmation_of(:email, :xxx => true)
        }.to raise_error(ArgumentError, /unknown.*:xxx/i)
      end
    end
  end

  context "description" do
    context "for a defined validation" do
      let(:matcher) { validate_confirmation_of(:email) }

      it 'contains a description' do
        matcher.description.should == 'validate confirmation of email'
      end
    end

    context "for an undefined validation" do
      let(:matcher) { validate_confirmation_of(:password) }

      before(:each) { matcher.matches?(subject) }

      it "sets a custom failure message for should" do
        matcher.failure_message.should ==
          'Expected User to validate confirmation of password'
      end

      it "sets a custom failure message for should not" do
        matcher.negative_failure_message.should ==
          'Did not expect User to validate confirmation of password'
      end
    end
  end
end
