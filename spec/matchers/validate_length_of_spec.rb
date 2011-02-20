require 'spec_helper'

describe "validates_length_of" do
  let(:attributes) { :name }
  let(:options) { 1..10 }

  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations

      attr_accessor :name, :email
    end
  end

  before(:each) do
    model.validates(*attributes, :length => options)
  end

  subject { model.new }

  context "with a single attribute" do
    it { should validate_length_of(:name) }
    it { should_not validate_length_of(:email) }
  end

  context "with multiple attributes" do
    let(:attributes) { [:name, :email] }

    it { should validate_length_of(:name, :email) }
  end

  with_option(:allow_blank, :is => 5, :allow_blank => true) do
    it { should validate_length_of(:name, :allow_blank => true) }
    it { should_not validate_length_of(:name, :allow_blank => false) }
  end

  with_option(:allow_nil, :is => 5, :allow_nil => true) do
    it { should validate_length_of(:name, :allow_nil => true) }
    it { should_not validate_length_of(:name, :allow_nil => false) }
  end

  with_option(:in, :in => 1..10) do
    it { should validate_length_of(:name, :in => 1..10) }
    it { should_not validate_length_of(:name, :in => 1..5) }
  end

  with_option(:is, :is => 5) do
    it { should validate_length_of(:name, :is => 5) }
    it { should_not validate_length_of(:name, :is => 10) }
  end

  with_option(:maximum, :maximum => 5) do
    it { should validate_length_of(:name, :maximum => 5) }
    it { should_not validate_length_of(:name, :maximum => 10) }
  end

  with_option(:message, :is => 5, :message => 'wrong length!') do
    it { should validate_length_of(:name, :message => 'wrong length!') }
    it { should_not validate_length_of(:name, :message => 'invalid') }
  end

  with_option(:minimum, :minimum => 5) do
    it { should validate_length_of(:name, :minimum => 5) }
    it { should_not validate_length_of(:name, :minimum => 10) }
  end

  with_option(:on, :is => 5, :on => :create) do
    it { should validate_length_of(:name, :on => :create) }
    it { should_not validate_length_of(:name, :on => :update) }
  end

  with_option(:too_long, :is => 5, :too_long => 'is too long!') do
    it { should validate_length_of(:name, :too_long => 'is too long!') }
    it { should_not validate_length_of(:name, :too_long => 'invalid') }
  end

  with_option(:too_short, :is => 5, :too_short => 'is too short!') do
    it { should validate_length_of(:name, :too_short => 'is too short!') }
    it { should_not validate_length_of(:name, :too_short => 'invalid') }
  end

  with_option(:within, :within => 1..10) do
    it { should validate_length_of(:name, :within => 1..10) }
    it { should_not validate_length_of(:name, :within => 1..5) }
  end

  with_option(:wrong_length, :is => 5, :wrong_length => 'is not five!') do
    it { should validate_length_of(:name, :wrong_length => 'is not five!') }
    it { should_not validate_length_of(:name, :wrong_length => 'invalid') }
  end

  with_unsupported_option(:if) do
    validate_length_of(:if => :allow_validation)
  end

  with_unsupported_option(:unless) do
    validate_length_of(:unless => :skip_validation)
  end

  with_unsupported_option(:tokenizer) do
    validate_length_of(:tokenizer => lambda { |string| string.scan(/\w+/) })
  end

  with_unknown_option(:xxx) do
    validate_length_of(:xxx => true)
  end

  has_description do
    validate_length_of(:name, :within => 1..10)
  end

  has_failure_messages do
    validate_length_of(:email, :within => 1..10)
  end
end
