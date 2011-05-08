require 'spec_helper'

describe :belong_to do
  let(:options) { [:company, :dependent => :destroy] }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    before(:each) do
      create_table(:users) do |table|
        table.integer :company_id
      end
    end

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
        association = matcher.instance_variable_get(:@association)
        with = " with #{matcher.expected}" if matcher.expected.any?
        matcher.description.should == "#{name} #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :company }

      it 'matches if the association exists' do
        model.belongs_to(*options)
        model.should belong_to(*options)
      end

      it "doesn't match if the association doesn't exist" do
        model.should_not belong_to(*options)
      end
    end

    with_option(:class_name, 'Company', 'Organization')
    with_option(:conditions, { :id => 1 }, { :id => 2 })
    with_option(:select, %w(id), %w(name))
    with_option(:foreign_key, :company_id, :organization_id)
    with_option(:dependent, :destroy, :nullify)
    with_option(:counter_cache, true, false)
    with_option(:include, :users, :employees)
    with_option(:polymorphic, true, false)
    with_option(:readonly, true, false)
    with_option(:validate, true, false)
    with_option(:autosave, true, false)
    with_option(:touch, true, false)
    with_option(:inverse_of, :users, :employees)

    with_unsupported_option(:extend, Module.new)
  end
end
