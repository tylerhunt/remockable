require 'spec_helper'

describe :validate_numericality_of do
  let(:validator_name) { :numericality }
  let(:default_options) { { :only_integer => true } }

  it_behaves_like 'a validation matcher' do
    with_option(:allow_nil, true, false)
    with_option(:equal_to, 5, 10)
    with_option(:even, true, false)
    with_option(:greater_than, 5, 10)
    with_option(:greater_than_or_equal_to, 5, 10)
    with_option(:less_than, 5, 10)
    with_option(:less_than_or_equal_to, 5, 10)
    with_option(:message, 'is the wrong numericality!', 'invalid')
    with_option(:odd, true, false)
    with_option(:on, :create, :update)
    with_option(:only_integer, true, false)

    with_conditional_option(:if)
    with_conditional_option(:unless)
  end
end
