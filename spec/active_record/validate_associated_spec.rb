require 'spec_helper'

describe :validate_associated do
  let(:validator_name) { :associated }
  let(:attributes) { :company }
  let(:default_options) { { :on => :create } }

  before(:each) do
    create_table(:users) do |table|
      table.string :company_id
    end
  end

  it_behaves_like 'a validation matcher' do
    let(:model) do
      build_class(:User, ActiveRecord::Base) do
        include ActiveRecord::Validations

        belongs_to :company
      end
    end

    with_option(:message, 'is not unique!', 'invalid')
    with_option(:on, :create, :update)

    with_unsupported_option(:if, :allow_validation)
    with_unsupported_option(:unless, :skip_validation)
  end
end
