require 'spec_helper'

describe :have_one do
  let(:macro) { :has_one }
  let(:options) { [:address, :dependent => :destroy] }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    before(:each) do
      create_table(:users) do |table|
        table.string :name
      end
    end

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        association = matcher.instance_variable_get(:@association)
        with = " with #{matcher.expected}" if matcher.expected.any?
        matcher.description.should == "have a #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :company }

      it 'matches if the association exists' do
        model.has_one(*options)
        model.should have_one(*options)
      end

      it "doesn't match if the association doesn't exist" do
        model.should_not have_one(*options)
      end
    end

    with_option(:class_name, 'Address', 'Location')
    with_option(:conditions, { :id => 1 }, { :id => 2 })
    with_option(:order, %w(id), %w(name))
    with_option(:dependent, :destroy, :nullify)
    with_option(:foreign_key, :address_id, :location_id)
    with_option(:primary_key, :id, :address_id)
    with_option(:include, :country, :state)
    with_option(:as, :addressable, :locatable)
    with_option(:select, %w(id), %w(name))
    with_option(:through, :offices, :locations)
    with_option(:readonly, true, false)
    with_option(:validate, true, false)
    with_option(:autosave, true, false)
    with_option(:inverse_of, :user, :employee)

    with_unsupported_option(:extend, Module.new)
  end
end
