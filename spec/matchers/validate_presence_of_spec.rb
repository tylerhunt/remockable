require 'spec_helper'

describe "validates_presence_of" do
  let(:attributes) { :name }
  let(:options) { true }

  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations

      attr_accessor :name, :email
    end
  end

  before(:each) do
    model.validates(*attributes, :presence => options)
  end

  subject { model.new }

  context "with a single attribute" do
    it { should validate_presence_of(:name) }
    it { should_not validate_presence_of(:email) }
  end

  context "with multiple attributes" do
    let(:attributes) { [:name, :email] }

    it { should validate_presence_of(:name, :email) }
  end

  with_option(:message, :message => 'is required!') do
    it { should validate_presence_of(:name, :message => 'is required!') }
    it { should_not validate_presence_of(:name, :message => 'invalid') }
  end

  with_option(:on, :on => :create) do
    it { should validate_presence_of(:name, :on => :create) }
    it { should_not validate_presence_of(:name, :on => :update) }
  end

  with_unsupported_option(:if) do
    validate_presence_of(:if => :allow_validation)
  end

  with_unsupported_option(:unless) do
    validate_presence_of(:unless => :skip_validation)
  end

  with_unknown_option(:xxx) do
    validate_presence_of(:xxx => true)
  end

  has_description do
    validate_presence_of(:name)
  end

  has_failure_messages do
    validate_presence_of(:email)
  end
end
