require 'spec_helper'

describe "validates_exclusion_of" do
  let(:attributes) { :admin }
  let(:options) { { :in => [true, false] } }

  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations

      attr_accessor :admin, :manager
    end
  end

  before(:each) do
    model.validates(*attributes, :exclusion => options)
  end

  subject { model.new }

  context "with a single attribute" do
    it { should validate_exclusion_of(:admin, :in => [true, false]) }
    it { should_not validate_exclusion_of(:manager, :in => [true, false]) }
  end

  context "with multiple attributes" do
    let(:attributes) { [:admin, :manager] }

    it { should validate_exclusion_of(:admin, :manager, :in => [true, false]) }
  end

  with_option(:allow_blank, :in => [true, false], :allow_blank => true) do
    it { should validate_exclusion_of(:admin, :in => [true, false], :allow_blank => true) }
    it { should_not validate_exclusion_of(:admin, :in => [true, false], :allow_blank => false) }
  end

  with_option(:allow_nil, :in => [true, false], :allow_nil => true) do
    it { should validate_exclusion_of(:admin, :in => [true, false], :allow_nil => true) }
    it { should_not validate_exclusion_of(:admin, :in => [true, false], :allow_nil => false) }
  end

  with_option(:in, :in => [true, false]) do
    it { should validate_exclusion_of(:admin, :in => [true, false]) }
    it { should_not validate_exclusion_of(:admin, :in => %w(superuser)) }
  end

  with_option(:message, :in => [true, false], :message => 'is invalid!') do
    it { should validate_exclusion_of(:admin, :in => [true, false], :message => 'is invalid!') }
    it { should_not validate_exclusion_of(:admin, :in => [true, false], :message => 'invalid') }
  end

  with_unsupported_option(:if) do
    validate_exclusion_of(:if => :allow_validation)
  end

  with_unsupported_option(:unless) do
    validate_exclusion_of(:unless => :skip_validation)
  end

  with_unknown_option(:xxx) do
    validate_exclusion_of(:xxx => true)
  end

  has_description do
    validate_exclusion_of(:admin, :in => [true, false])
  end

  has_failure_messages do
    validate_exclusion_of(:manager, :in => [true, false])
  end
end
