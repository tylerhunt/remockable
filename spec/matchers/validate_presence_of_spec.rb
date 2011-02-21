require 'spec_helper'

describe :validate_presence_of do
  let(:validator_name) { :presence }
  let(:default_options) { true }

  it_behaves_like 'a validation matcher', :presence do
    with_option(:message, 'is required!', 'invalid')
    with_option(:on, :create, :update)

    with_unsupported_option(:if, :allow_validation)
    with_unsupported_option(:unless, :skip_validation)
  end
end
