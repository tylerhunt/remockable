describe :validate_confirmation_of do
  let(:validator_name) { :confirmation }
  let(:default_options) { true }

  it_behaves_like 'a validation matcher' do
    with_option(:message, 'must match!', 'invalid')
    with_option(:on, :create, :update)

    with_conditional_option(:if)
    with_conditional_option(:unless)
  end
end
