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

  context "matcher" do
    context "with a single attribute" do
      it { should validate_length_of(:name) }
      it { should_not validate_length_of(:email) }
    end

    context "with multiple attributes" do
      let(:attributes) { [:name, :email] }

      it { should validate_length_of(:name, :email) }
    end

    context "with option :allow_blank" do
      let(:options) { { :is => 5, :allow_blank => true } }

      it { should validate_length_of(:name, :allow_blank => true) }
      it { should_not validate_length_of(:name, :allow_blank => false) }
    end

    context "with option :allow_nil" do
      let(:options) { { :is => 5, :allow_nil => true } }

      it { should validate_length_of(:name, :allow_nil => true) }
      it { should_not validate_length_of(:name, :allow_nil => false) }
    end

    context "with option :in" do
      let(:options) { { :in => 1..10 } }

      it { should validate_length_of(:name, :in => 1..10) }
      it { should_not validate_length_of(:name, :in => 1..5) }
    end

    context "with option :is" do
      let(:options) { { :is => 5 } }

      it { should validate_length_of(:name, :is => 5) }
      it { should_not validate_length_of(:name, :is => 10) }
    end

    context "with option :maximum" do
      let(:options) { { :maximum => 5 } }

      it { should validate_length_of(:name, :maximum => 5) }
      it { should_not validate_length_of(:name, :maximum => 10) }
    end

    context "with option :message" do
      let(:options) { { :is => 5, :message => 'is long enough!' } }

      it { should validate_length_of(:name, :message => 'is long enough!') }
      it { should_not validate_length_of(:name, :message => 'invalid') }
    end

    context "with option :minimum" do
      let(:options) { { :minimum => 5 } }

      it { should validate_length_of(:name, :minimum => 5) }
      it { should_not validate_length_of(:name, :minimum => 10) }
    end

    context "with option :on" do
      let(:options) { { :is => 5, :on => :create } }

      it { should validate_length_of(:name, :on => :create) }
      it { should_not validate_length_of(:name, :on => :update) }
    end

    context "with option :too_long" do
      let(:options) { { :is => 5, :too_long => 'is too long!' } }

      it { should validate_length_of(:name, :too_long => 'is too long!') }
      it { should_not validate_length_of(:name, :too_long => 'invalid') }
    end

    context "with option :too_short" do
      let(:options) { { :is => 5, :too_short => 'is too short!' } }

      it { should validate_length_of(:name, :too_short => 'is too short!') }
      it { should_not validate_length_of(:name, :too_short => 'invalid') }
    end

    context "with option :within" do
      let(:options) { { :within => 1..10 } }

      it { should validate_length_of(:name, :within => 1..10) }
      it { should_not validate_length_of(:name, :within => 1..5) }
    end

    context "with option :wrong_length" do
      let(:options) { { :is => 5, :wrong_length => 'is not five!' } }

      it { should validate_length_of(:name, :wrong_length => 'is not five!') }
      it { should_not validate_length_of(:name, :wrong_length => 'invalid') }
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

    context "with unsupported option :tokenizer" do
      it "raises an error" do
        expect {
          validate_length_of(:name, :tokenizer => :allow_validation)
        }.to raise_error(ArgumentError, /unsupported.*:tokenizer/i)
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
      let(:matcher) { validate_length_of(:name, :within => 1..10) }

      it 'contains a description' do
        matcher.description.should ==
          'validate length of name with {:within=>1..10}'
      end
    end

    context "for an undefined validation" do
      let(:matcher) { validate_length_of(:email, :within => 1..10) }

      before(:each) { matcher.matches?(subject) }

      it "sets a custom failure message for should" do
        matcher.failure_message.should ==
          'Expected User to validate length of email with {:within=>1..10}'
      end

      it "sets a custom failure message for should not" do
        matcher.negative_failure_message.should ==
          'Did not expect User to validate length of email with {:within=>1..10}'
      end
    end
  end
end
