shared_examples_for 'an Active Record matcher' do
  let(:matcher_name) { self.class.parent.parent.description }

  def self.with_option(option_name, positive, negative, context={})
    context "with option #{option_name.inspect}" do
      let(:options) { [:company, context.merge(option_name => positive)] }

      before do
        model.send macro, *options
      end

      it 'matches if the options match' do
        should send(matcher_name, :company, option_name => positive)
      end

      it 'does not match if the options do not match' do
        should_not send(matcher_name, :company, option_name => negative)
      end
    end
  end

  def self.with_unsupported_option(option_name, value=nil)
    context "with unsupported option #{option_name.inspect}" do
      it 'raises an error' do
        expect { send(matcher_name, :company, option_name => value) }
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
      expect(matcher.failure_message_for_should)
        .to eq "Expected #{subject.class.name} to #{matcher.description}"
    end

    it 'has a custom negative failure message' do
      expect(matcher.failure_message_for_should_not)
        .to eq "Did not expect #{subject.class.name} to #{matcher.description}"
    end
  end

  context 'with an unknown option' do
    it 'raises an error' do
      expect { send(matcher_name, xxx: true) }
        .to raise_error ArgumentError, /unknown.*:xxx/i
    end
  end
end
