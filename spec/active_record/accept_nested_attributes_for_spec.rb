require 'spec_helper'

describe :accept_nested_attributes_for do
  let(:macro) { :accepts_nested_attributes_for }
  let(:options) { [:company, { :allow_destroy => true }] }

  it_behaves_like 'an Active Record matcher' do
    let(:matcher_name) { :accept_nested_attributes_for }

    let(:model) do
      build_class(:User, ActiveRecord::Base) { belongs_to :company }
    end

    before { create_table(:users) }

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        association = matcher.instance_variable_get(:@association)
        with = " with #{matcher.expected.inspect}" if matcher.expected.any?
        matcher.description.should == "accept nested attributes for #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :company }

      it 'matches if the model accepts the nested attributes' do
        model.accepts_nested_attributes_for(*options)
        model.should accept_nested_attributes_for(*options)
      end

      it 'does not match if the model does not accept the nested attributes' do
        model.should_not accept_nested_attributes_for(*options)
      end
    end

    with_option(:allow_destroy, true, false)
    with_option(:limit, 1, 2)
    with_option(:update_only, true, false)

    with_unsupported_option(:reject_if, :all_blank)
  end
end
