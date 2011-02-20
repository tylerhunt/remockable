module RSpecHelpers
  module ClassMethods
    def has_unsupported_option(matcher, option)
      option_name = option.keys.first

      context "with unsupported option #{option_name}" do
        it "raises an error" do
          expect {
            send(matcher, option)
          }.to raise_error(ArgumentError, /unsupported.*:#{option_name}/i)
        end
      end
    end

    def has_unknown_option(matcher, option)
      option_name = option.keys.first

      context "with unknown option #{option_name}" do
        it "raises an error" do
          expect {
            validate_confirmation_of(matcher, option)
          }.to raise_error(ArgumentError, /unknown.*:#{option_name}/i)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.extend(RSpecHelpers::ClassMethods)
end
