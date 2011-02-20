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

    has_unsupported_option(:validate_confirmation_of, :if => :allow_validation)
    has_unsupported_option(:validate_confirmation_of, :unless => :allow_validation)
    has_unknown_option(:validate_confirmation_of, :xxx => true)
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
