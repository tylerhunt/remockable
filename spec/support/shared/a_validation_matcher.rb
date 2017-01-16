shared_examples_for 'a validation matcher' do
  let(:attribute) { :one }
  let(:options) { default_options }
  let(:matcher_name) { self.class.parent.parent.description }

  let(:model) {
    build_class :User do
      include ActiveModel::Validations
    end
  }

  subject(:instance) { model.new }

  before do
    model.validates attribute, validator_name => options
  end

  def self.with_option(option_name, positive, negative, exclusive=false)
    context "with option #{option_name.inspect}" do
      let(:options) {
        option = { option_name => positive }
        merge_with_default = !exclusive && default_options.is_a?(Hash)
        merge_with_default ? default_options.merge(option) : option
      }

      it 'matches if the options match' do
        should send(matcher_name, attribute, option_name => positive)
      end

      it 'does not match if the options do not match' do
        should_not send(matcher_name, attribute, option_name => negative)
      end
    end
  end

  def self.with_option!(option_name, positive, negative)
    with_option option_name, positive, negative, true
  end

  def self.with_conditional_option(option_name)
    context "with option #{option_name.inspect} with a symbol" do
      let(:options) {
        option = { option_name => :returns_true }
        default_options.is_a?(Hash) ? default_options.merge(option) : option
      }

      it 'matches if the options match' do
        should send(matcher_name, attribute, option_name => :returns_true)
      end

      it 'does not match if the options do not match' do
        should_not send(matcher_name, attribute, option_name => :returns_false)
      end
    end

    context "with option #{option_name.inspect} with a procedure" do
      before do
        model.class_eval do
          define_method(:skip_validations) {}
        end
      end

      let(:procedure) { ->(record) { record.skip_validations } }

      let(:options) {
        option = { option_name => procedure }
        default_options.is_a?(Hash) ? default_options.merge(option) : option
      }

      it 'matches if the options match' do
        allow(instance).to receive(:skip_validations).and_return(true)
        should send(matcher_name, attribute, option_name => true)
      end

      it 'does not match if the options do not match' do
        allow(instance).to receive(:skip_validations).and_return(false)
        should_not send(matcher_name, attribute, option_name => true)
      end
    end
  end

  def self.with_unsupported_option(option_name, value=nil)
    context "with unsupported option #{option_name.inspect}" do
      it 'raises an error' do
        expect { should send(matcher_name, option_name => value) }
          .to raise_error ArgumentError, /unsupported.*:#{option_name}/i
      end
    end
  end

  context 'description' do
    let(:matcher) { send(matcher_name, attribute) }

    it 'has a custom description' do
      name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
      with = " with #{matcher.options}" if matcher.options.any?

      expect(matcher.description).to eq "#{name} #{attribute}#{with}"
    end
  end

  context 'failure messages' do
    let(:matcher) { send(matcher_name, attribute) }

    before do
      matcher.matches?(instance)
    end

    it 'has a custom failure message' do
      expect(matcher.failure_message)
        .to eq "Expected #{instance.class.name} to #{matcher.description}"
    end

    it 'has a custom negative failure message' do
      expect(matcher.failure_message_when_negated)
        .to eq "Did not expect #{instance.class.name} to #{matcher.description}"
    end
  end

  context 'without options' do
    it 'matches if the validator has been defined' do
      should send(matcher_name, :one)
    end

    it 'does not match if the validator has not been defined' do
      should_not send(matcher_name, :two)
    end
  end

  context 'with an unknown option' do
    it 'raises an error' do
      expect { should send(matcher_name, xxx: true) }
        .to raise_error ArgumentError, /unknown.*:xxx/i
    end
  end
end
