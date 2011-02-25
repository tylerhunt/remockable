require 'spec_helper'

describe :validate_acceptance_of do
  let(:validator_name) { :acceptance }
  let(:default_options) { true }

  it_behaves_like 'a validation matcher' do
    with_option(:accept, 'TRUE', 'FALSE')
    with_option(:allow_nil, true, false)
    with_option(:message, 'must agree!', 'invalid')
    with_option(:on, :create, :update)

    with_unsupported_option(:if, :allow_validation)
    with_unsupported_option(:unless, :skip_validation)
  end
end
