shared_examples_for 'a validation matcher' do
  let(:attributes) { single_attribute }
  let(:default_options) { {} }
  let(:options) { default_options }
  let(:matcher_name) { self.class.parent.parent.description }

  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations

      attr_accessor :name, :email, :password
      attr_accessor :admin, :manager
      attr_accessor :terms, :eula
    end
  end

  before(:each) do
    model.validates(*attributes, validator_name => options)
  end

  subject { model.new }

  def self.with_option(option_name, positive, negative)
    context "with option #{option_name.inspect}" do
      let(:options) do
        option = { option_name => positive }
        default_options.is_a?(Hash) ? default_options.merge(option) : option
      end

      it { should send(matcher_name, *attributes, option_name => positive) }
      it { should_not send(matcher_name, *attributes, option_name => negative) }
    end
  end

  def self.with_unsupported_option(option_name, value=nil)
    context "with unsupported option #{option_name.inspect}" do
      it "raises an error" do
        expect {
          send(matcher_name, option_name => value)
        }.to raise_error(ArgumentError, /unsupported.*:#{option_name}/i)
      end
    end
  end

  context 'description' do
    let(:matcher) { send(matcher_name, *attributes) }

    it 'has a custom description' do
      name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
      attributes = matcher.instance_variable_get(:@attributes).to_sentence
      with = " with #{matcher.expected}" if matcher.expected.any?

      matcher.description.should == "#{name} #{attributes}#{with}"
    end
  end

  context 'failure messages' do
    let(:matcher) { send(matcher_name, *attributes) }

    before(:each) { matcher.matches?(subject) }

    it 'has a custom failure message' do
      matcher.failure_message.should ==
        "Expected #{subject.class.name} to #{matcher.description}"
    end

    it 'sets a custom negative failure message' do
      matcher.negative_failure_message.should ==
        "Did not expect #{subject.class.name} to #{matcher.description}"
    end
  end

  context "with a single attribute" do
    it { should send(matcher_name, single_attribute) }
    it { should_not send(matcher_name, *(multiple_attributes - Array(attributes))) }
  end

  context "with multiple attributes" do
    let(:attributes) { multiple_attributes }

    it { should send(matcher_name, *multiple_attributes) }
  end

  context "with an unknown option" do
    it "raises an error" do
      expect {
        send(matcher_name, :xxx => true)
      }.to raise_error(ArgumentError, /unknown.*:xxx/i)
    end
  end
end
