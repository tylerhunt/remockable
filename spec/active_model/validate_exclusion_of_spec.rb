require 'spec_helper'

describe :validate_exclusion_of do
  let(:validator_name) { :exclusion }
  let(:default_options) { { :in => [true, false] } }

  it_behaves_like 'a validation matcher' do
    with_option(:allow_blank, true, false)
    with_option(:allow_nil, true, false)
    with_option(:in, [true, false], %w(male female))
    with_option(:message, 'is in list!', 'invalid')

    with_unsupported_option(:if, :allow_validation)
    with_unsupported_option(:unless, :skip_validation)
  end
end
