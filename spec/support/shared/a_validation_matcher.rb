shared_examples_for 'a validation matcher' do
  let(:attributes) { :one }
  let(:options) { default_options }
  let(:matcher_name) { self.class.parent.parent.description }

  let(:model) do
    build_class(:User) do
      include ActiveModel::Validations
    end
  end

  before(:each) do
    model.validates(*attributes, validator_name => options)
  end

  subject { model.new }

  def self.with_option(option_name, positive, negative, exclusive=false)
    context "with option #{option_name.inspect}" do
      let(:options) do
        option = { option_name => positive }
        merge_with_default = !exclusive && default_options.is_a?(Hash)
        merge_with_default ? default_options.merge(option) : option
      end

      it 'matches if the options match' do
        should send(matcher_name, *attributes, option_name => positive)
      end

      it "doesn't match if the options don't match" do
        should_not send(matcher_name, *attributes, option_name => negative)
      end
    end
  end

  def self.with_option!(option_name, positive, negative)
    with_option(option_name, positive, negative, true)
  end

  def self.with_unsupported_option(option_name, value=nil)
    context "with unsupported option #{option_name.inspect}" do
      it 'raises an error' do
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
    it 'matches if the validator has been defined' do
      should send(matcher_name, :one)
    end

    it "doesn't match if the validator hasn't been defined" do
      should_not send(matcher_name, :two)
    end
  end

  context "with multiple attributes" do
    let(:attributes) { [:one, :two] }

    it 'matches if the validators have been defined' do
      should send(matcher_name, :one, :two)
    end

    it "doesn't match if the validators haven't been defined" do
      should_not send(matcher_name, :one, :two, :trhee)
    end
  end

  context "with an unknown option" do
    it 'raises an error' do
      expect {
        send(matcher_name, :xxx => true)
      }.to raise_error(ArgumentError, /unknown.*:xxx/i)
    end
  end
end
