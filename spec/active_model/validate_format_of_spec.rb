require 'spec_helper'

describe :validate_format_of do
  let(:validator_name) { :format }
  let(:default_options) { { :with => /\d+/ } }

  it_behaves_like 'a validation matcher' do
    with_option(:allow_blank, true, false)
    with_option(:allow_nil, true, false)
    with_option(:message, 'is the wrong format!', 'invalid')
    with_option(:on, :create, :update)
    with_option!(:with, /\d+/, /\w+/)
    with_option!(:without, /\d+/, /\w+/)

    with_conditional_option(:if)
    with_conditional_option(:unless)
  end
end
