require 'spec_helper'

describe :validate_confirmation_of do
  let(:validator_name) { :confirmation }

  it_behaves_like 'a validation matcher' do
    let(:single_attribute) { :email }
    let(:multiple_attributes) { [:email, :password] }
    let(:default_options) { true }

    with_option(:message, 'must match!', 'invalid')
    with_option(:on, :create, :update)

    with_unsupported_option(:if, :allow_validation)
    with_unsupported_option(:unless, :skip_validation)
  end
end
