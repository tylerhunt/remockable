module RSpecHelpers
  module ClassMethods
    def with_option(option_name, options, &block)
      context "with option #{option_name.inspect}" do
        let(:options) { options }

        class_eval(&block)
      end
    end

    def with_unsupported_option(option_name, &block)
      context "with unsupported option #{option_name.inspect}" do
        it "raises an error" do
          expect {
            instance_eval(&block)
          }.to raise_error(ArgumentError, /unsupported.*:#{option_name}/i)
        end
      end
    end

    def with_unknown_option(option_name, &block)
      context "with unknown option #{option_name.inspect}" do
        it "raises an error" do
          expect {
            instance_eval(&block)
          }.to raise_error(ArgumentError, /unknown.*#{option_name.inspect}/i)
        end
      end
    end

    def has_description(&block)
      context 'description' do
        let(:matcher, &block)

        it 'has a custom description' do
          name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
          attributes = matcher.instance_variable_get(:@attributes).to_sentence
          with = " with #{matcher.expected}" if matcher.expected.any?

          matcher.description.should == "#{name} #{attributes}#{with}"
        end
      end
    end

    def has_failure_messages(&block)
      context 'failure messages' do
        let(:matcher, &block)

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
    end
  end
end

RSpec.configure do |config|
  config.extend(RSpecHelpers::ClassMethods)
end
