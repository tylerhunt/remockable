require 'spec_helper'

describe :validate_associated do
  let(:validator_name) { :associated }
  let(:attribute) { :company }
  let(:default_options) { { on: :create } }

  before do
    create_table :users do |table|
      table.string :company_id
    end
  end

  it_behaves_like 'a validation matcher' do
    let(:model) {
      build_class :User, ActiveRecord::Base do
        include ActiveRecord::Validations

        belongs_to :company
      end
    }

    with_option :message, 'is not unique!', 'invalid'
    with_option :on, :create, :update

    with_conditional_option :if
    with_conditional_option :unless
  end
end
