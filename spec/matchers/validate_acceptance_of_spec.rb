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

  context "with a single attribute" do
    it { should validate_acceptance_of(:terms) }
    it { should_not validate_acceptance_of(:eula) }
  end

  context "with multiple attributes" do
    let(:attributes) { [:terms, :eula] }

    it { should validate_acceptance_of(:terms, :eula) }
  end

  with_option(:accept, :accept => 'TRUE') do
    it { should validate_acceptance_of(:terms, :accept => 'TRUE') }
    it { should_not validate_acceptance_of(:terms, :accept => 'FALSE') }
  end

  with_option(:allow_nil, :allow_nil => true) do
    it { should validate_acceptance_of(:terms, :allow_nil => true) }
    it { should_not validate_acceptance_of(:terms, :allow_nil => false) }
  end

  with_option(:message, :message => 'must agree!') do
    it { should validate_acceptance_of(:terms, :message => 'must agree!') }
    it { should_not validate_acceptance_of(:terms, :message => 'invalid') }
  end

  with_option(:on, :on => :create) do
    it { should validate_acceptance_of(:terms, :on => :create) }
    it { should_not validate_acceptance_of(:terms, :on => :update) }
  end

  with_unsupported_option(:if) do
    validate_acceptance_of(:if => :allow_validation)
  end

  with_unsupported_option(:unless) do
    validate_acceptance_of(:unless => :skip_validation)
  end

  with_unknown_option(:xxx) do
    validate_acceptance_of(:xxx => true)
  end

  has_description do
    validate_acceptance_of(:terms)
  end

  has_failure_messages do
    validate_acceptance_of(:eula)
  end
end
