require 'spec_helper'

describe :validate_length_of do
  let(:validator_name) { :length }
  let(:default_options) { { :is => 5 } }

  it_behaves_like 'a validation matcher' do
    with_option(:allow_blank, true, false)
    with_option(:allow_nil, true, false)
    with_option(:in, 1..10, 1..5)
    with_option(:is, 5, 10)
    with_option(:maximum, 5, 10)
    with_option(:message, 'is the wrong length!', 'invalid')
    with_option(:minimum, 5, 10)
    with_option(:on, :create, :update)
    with_option(:too_long, 'is too long!', 'invalid')
    with_option(:too_short, 'is too short!', 'invalid')
    with_option(:within, 1..10, 1..5)
    with_option(:wrong_length, 'is not five!', 'invalid')

    with_conditional_option(:if)
    with_conditional_option(:unless)

    with_unsupported_option(:tokenizer, lambda { |string| string.scan(/\w+/) })
  end
end
