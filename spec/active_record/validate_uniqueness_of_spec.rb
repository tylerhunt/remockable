require 'spec_helper'

describe :validate_uniqueness_of do
  let(:validator_name) { :uniqueness }
  let(:default_options) { { scope: :two } }

  it_behaves_like 'a validation matcher' do
    let(:model) {
      build_class :User do
        include ActiveRecord::Validations
      end
    }

    with_option :allow_blank, true, false
    with_option :allow_nil, true, false
    with_option :case_sensitive, true, false
    with_option :message, 'is not unique!', 'invalid'
    with_option :scope, :two, :three

    with_conditional_option :if
    with_conditional_option :unless
  end
end
