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

  context "with a single attribute" do
    it { should validate_confirmation_of(:email) }
    it { should_not validate_confirmation_of(:password) }
  end

  context "with multiple attributes" do
    let(:attributes) { [:email, :password] }

    it { should validate_confirmation_of(:email, :password) }
  end

  with_option(:message, :message => 'must match!') do
    it { should validate_confirmation_of(:email, :message => 'must match!') }
    it { should_not validate_confirmation_of(:email, :message => 'invalid') }
  end

  with_option(:on, :on => :create) do
    it { should validate_confirmation_of(:email, :on => :create) }
    it { should_not validate_confirmation_of(:email, :on => :update) }
  end

  with_unsupported_option(:if) do
    validate_confirmation_of(:if => :allow_validation)
  end

  with_unsupported_option(:unless) do
    validate_confirmation_of(:unless => :skip_validation)
  end

  with_unknown_option(:xxx) do
    validate_confirmation_of(:xxx => true)
  end

  has_description do
    validate_confirmation_of(:email)
  end

  has_failure_messages do
    validate_confirmation_of(:password)
  end
end
