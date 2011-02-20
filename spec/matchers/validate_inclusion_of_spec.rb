require 'spec_helper'

describe :validate_inclusion_of do
  let(:validator_name) { :inclusion }

  it_behaves_like 'a validation matcher' do
    let(:single_attribute) { :admin }
    let(:multiple_attributes) { [:admin, :manager] }
    let(:default_options) { { :in => [true, false] } }

    with_option(:allow_blank, true, false)
    with_option(:allow_nil, true, false)
    with_option(:in, [true, false], %w(male female))
    with_option(:message, 'is not in list!', 'invalid')

    with_unsupported_option(:if, :allow_validation)
    with_unsupported_option(:unless, :skip_validation)
  end
end
