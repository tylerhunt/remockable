require 'spec_helper'

describe :have_one do
  let(:macro) { :has_one }
  let(:options) { [:address, { dependent: :destroy }] }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    subject(:instance) { model.new }

    before do
      create_table :users do |table|
        table.string :name
      end
    end

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        association = matcher.instance_variable_get(:@association)
        with = " with #{matcher.expected.inspect}" if matcher.expected.any?

        expect(matcher.description).to eq "have a #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :address }

      it 'matches if the association exists' do
        model.has_one *options
        expect(model).to have_one *options
      end

      it 'does not match if the association does not exist' do
        expect(model).to_not have_one *options
      end

      it 'does not match if the association is of the wrong type' do
        model.has_many *options
        expect(model).to_not have_one *options
      end
    end

    with_option :class_name, 'Address', 'Location'
    with_option :dependent, :destroy, :nullify
    with_option :foreign_key, :address_id, :location_id
    with_option :primary_key, :id, :address_id
    with_option :as, :addressable, :locatable
    with_option :through, :offices, :locations
    with_option :source, :addressable, :contactable, through: :offices
    with_option :source_type, 'Company', 'Organization', through: :offices
    with_option :validate, true, false
    with_option :autosave, true, false
    with_option :inverse_of, :user, :employee
  end
end
