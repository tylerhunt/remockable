require 'spec_helper'

describe "validates_inclusion_of" do
  let(:attributes) { :admin }
  let(:options) { { :in => [true, false] } }

  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations

      attr_accessor :admin, :manager
    end
  end

  before(:each) do
    model.validates(*attributes, :inclusion => options)
  end

  subject { model.new }

  context "matcher" do
    context "with a single attribute" do
      it { should validate_inclusion_of(:admin, :in => [true, false]) }
      it { should_not validate_inclusion_of(:manager, :in => [true, false]) }
    end

    context "with multiple attributes" do
      let(:attributes) { [:admin, :manager] }

      it { should validate_inclusion_of(:admin, :manager, :in => [true, false]) }
    end

    context "with option :allow_blank" do
      let(:options) { { :in => [true, false], :allow_blank => true } }

      it { should validate_inclusion_of(:admin, :in => [true, false], :allow_blank => true) }
      it { should_not validate_inclusion_of(:admin, :in => [true, false], :allow_blank => false) }
    end

    context "with option :allow_nil" do
      let(:options) { { :in => [true, false], :allow_nil => true } }

      it { should validate_inclusion_of(:admin, :in => [true, false], :allow_nil => true) }
      it { should_not validate_inclusion_of(:admin, :in => [true, false], :allow_nil => false) }
    end

    context "with option :in" do
      let(:options) { { :in => [true, false] } }

      it { should validate_inclusion_of(:admin, :in => [true, false]) }
      it { should_not validate_inclusion_of(:admin, :in => %w(superuser)) }
    end

    context "with option :message" do
      let(:options) { { :in => [true, false], :message => 'is invalid!' } }

      it { should validate_inclusion_of(:admin, :in => [true, false], :message => 'is invalid!') }
      it { should_not validate_inclusion_of(:admin, :in => [true, false], :message => 'invalid') }
    end

    context "with unsupported option :if" do
      it "raises an error" do
        expect {
          validate_inclusion_of(:admin, :if => :allow_validation)
        }.to raise_error(ArgumentError, /unsupported.*:if/i)
      end
    end

    context "with unsupported option :unless" do
      it "raises an error" do
        expect {
          validate_inclusion_of(:admin, :unless => :allow_validation)
        }.to raise_error(ArgumentError, /unsupported.*:unless/i)
      end
    end

    context "with an unknown option" do
      it "raises an error" do
        expect {
          validate_inclusion_of(:admin, :xxx => true)
        }.to raise_error(ArgumentError, /unknown.*:xxx/i)
      end
    end
  end

  context "description" do
    context "for a defined validation" do
      let(:matcher) { validate_inclusion_of(:admin, :in => [true, false]) }

      it 'contains a description' do
        matcher.description.should ==
          'validate inclusion of admin with {:in=>[true, false]}'
      end
    end

    context "for an undefined validation" do
      let(:matcher) { validate_inclusion_of(:admin, :in => [true, false]) }

      before(:each) { matcher.matches?(subject) }

      it "sets a custom failure message for should" do
        matcher.failure_message.should ==
          'Expected User to validate inclusion of admin with {:in=>[true, false]}'
      end

      it "sets a custom failure message for should not" do
        matcher.negative_failure_message.should ==
          'Did not expect User to validate inclusion of admin with {:in=>[true, false]}'
      end
    end
  end
end
