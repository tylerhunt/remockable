require 'spec_helper'

describe "validates_acceptance_of" do
  let(:attributes) { :terms }
  let(:options) { true }

  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations

      attr_accessor :terms, :eula
    end
  end

  before(:each) do
    model.validates(*attributes, :acceptance => options)
  end

  subject { model.new }

  context "matcher" do
    context "with a single attribute" do
      it { should validate_acceptance_of(:terms) }
      it { should_not validate_acceptance_of(:eula) }
    end

    context "with multiple attributes" do
      let(:attributes) { [:terms, :eula] }

      it { should validate_acceptance_of(:terms, :eula) }
    end

    context "with option :accept" do
      let(:options) { { :accept => 'TRUE' } }

      it { should validate_acceptance_of(:terms, :accept => 'TRUE') }
      it { should_not validate_acceptance_of(:terms, :accept => 'FALSE') }
    end

    context "with option :allow_nil" do
      let(:options) { { :allow_nil => true } }

      it { should validate_acceptance_of(:terms, :allow_nil => true) }
      it { should_not validate_acceptance_of(:terms, :allow_nil => false) }
    end

    context "with option :message" do
      let(:options) { { :message => 'must agree!' } }

      it { should validate_acceptance_of(:terms, :message => 'must agree!') }
      it { should_not validate_acceptance_of(:terms, :message => 'invalid') }
    end

    context "with option :on" do
      let(:options) { { :on => :create } }

      it { should validate_acceptance_of(:terms, :on => :create) }
      it { should_not validate_acceptance_of(:terms, :on => :update) }
    end

    has_unsupported_option(:validate_acceptance_of, :if => :allow_validation)
    has_unsupported_option(:validate_acceptance_of, :unless => :allow_validation)
    has_unknown_option(:validate_acceptance_of, :xxx => true)
  end

  context "description" do
    context "for a defined validation" do
      let(:matcher) { validate_acceptance_of(:terms) }

      it 'contains a description' do
        matcher.description.should == 'validate acceptance of terms'
      end
    end

    context "for an undefined validation" do
      let(:matcher) { validate_acceptance_of(:eula) }

      before(:each) { matcher.matches?(subject) }

      it "sets a custom failure message for should" do
        matcher.failure_message.should ==
          'Expected User to validate acceptance of eula'
      end

      it "sets a custom failure message for should not" do
        matcher.negative_failure_message.should ==
          'Did not expect User to validate acceptance of eula'
      end
    end
  end
end
