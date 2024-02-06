shared_examples_for 'an Active Record matcher' do
  let(:matcher_name) do
    if self.class.respond_to?(:module_parent)
      self.class.module_parent.module_parent.description
    else
      self.class.parent.parent.description
    end
  end

  def self.with_option(
    option_name,
    positive,
    negative,
    context={},
    macro_option=nil,
    &block
  )
    context "with option #{option_name.inspect}" do
      let(:option_name) { option_name }
      let(:value) { positive }

      let(:options) { context.merge(macro_option || { option_name => value }) }

      before do
        model.send macro, :company, **options
      end

      it 'matches if the options match' do
        should send(matcher_name, :company, option_name => positive)
      end

      it 'does not match if the options do not match' do
        should_not send(matcher_name, :company, option_name => negative)
      end

      instance_exec &block if block_given?
    end
  end

  def self.raise_on_invalid_value(value, error_message)
    value_description = value.is_a?(Proc) ? 'proc' : value.inspect

    context "with #{value_description} value" do
      let(:value) { value }

      it 'raises an error' do
        expect { should send(matcher_name, :company, option_name => value) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  def self.with_unsupported_option(option_name, value=nil)
    context "with unsupported option #{option_name.inspect}" do
      it 'raises an error' do
        expect { should send(matcher_name, :company, option_name => value) }
          .to raise_error ArgumentError, /unsupported.*:#{option_name}/i
      end
    end
  end

  context 'failure messages' do
    let(:matcher) { send(matcher_name, *options) }

    before do
      matcher.matches? subject
    end

    it 'has a custom failure message' do
      expect(matcher.failure_message)
        .to eq "Expected #{subject.class.name} to #{matcher.description}"
    end

    it 'has a custom negative failure message' do
      expect(matcher.failure_message_when_negated)
        .to eq "Did not expect #{subject.class.name} to #{matcher.description}"
    end
  end

  context 'with an unknown option' do
    it 'raises an error' do
      expect { should send(matcher_name, xxx: true) }
        .to raise_error ArgumentError, /unknown.*:xxx/i
    end
  end
end
