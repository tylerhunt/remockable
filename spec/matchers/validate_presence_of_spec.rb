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

  context "matcher" do
    context "with a single attribute" do
      it { should validate_presence_of(:name) }
      it { should_not validate_presence_of(:email) }
    end

    context "with multiple attributes" do
      let(:attributes) { [:name, :email] }

      it { should validate_presence_of(:name, :email) }
    end

    context "with option :message" do
      let(:options) { { :message => 'is required!' } }

      it { should validate_presence_of(:name, :message => 'is required!') }
      it { should_not validate_presence_of(:name, :message => 'invalid') }
    end

    context "with option :on" do
      let(:options) { { :on => :create } }

      it { should validate_presence_of(:name, :on => :create) }
      it { should_not validate_presence_of(:name, :on => :update) }
    end

    context "with unsupported option :if" do
      it "raises an error" do
        expect {
          validate_length_of(:name, :if => :allow_validation)
        }.to raise_error(ArgumentError, /unsupported.*:if/i)
      end
    end

    context "with unsupported option :unless" do
      it "raises an error" do
        expect {
          validate_length_of(:name, :unless => :allow_validation)
        }.to raise_error(ArgumentError, /unsupported.*:unless/i)
      end
    end

    context "with an unknown option" do
      it "raises an error" do
        expect {
          validate_length_of(:name, :xxx => true)
        }.to raise_error(ArgumentError, /unknown.*:xxx/i)
      end
    end
  end

  context "description" do
    context "for a defined validation" do
      let(:matcher) { validate_presence_of(:name) }

      it 'contains a description' do
        matcher.description.should == 'validate presence of name'
      end
    end

    context "for an undefined validation" do
      let(:matcher) { validate_presence_of(:email) }

      before(:each) { matcher.matches?(subject) }

      it "sets a custom failure message for should" do
        matcher.failure_message.should ==
          'Expected User to validate presence of email'
      end

      it "sets a custom failure message for should not" do
        matcher.negative_failure_message.should ==
          'Did not expect User to validate presence of email'
      end
    end
  end
end
