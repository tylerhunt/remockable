require 'spec_helper'

describe :have_scope do
  let(:options) { :one }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    subject(:instance) { model.new }

    before do
      create_table :users do |table|
        table.string :one
      end
    end

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
        with = " with #{matcher.expected}" if matcher.expected.any?

        expect(matcher.description).to eq "have scope #{name}#{with}"
      end
    end

    context 'with a scope name' do
      it 'matches if the scope exists' do
        model.instance_eval { scope :no_one, -> { where one: nil } }
        expect(model).to have_scope :no_one
      end

      it 'does not match if the scope does not exist' do
        expect(model).to_not have_scope :no_one
      end
    end

    context 'with an eager_load value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :loaded, -> { eager_load :order } }
        expect(model).to have_scope(:loaded).eager_load(:order)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :loaded, -> { eager_load :order } }
        expect(model).to_not have_scope(:loaded).eager_load(:from)
      end
    end

    context 'with a from value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :used, -> { from 'users' } }
        expect(model).to have_scope(:used).from('users')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :used, -> { from 'users' } }
        expect(model).to_not have_scope(:used).from('friends')
      end
    end

    context 'with a group value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :grouped, -> { group 'one' } }
        expect(model).to have_scope(:grouped).group('one')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :grouped, -> { group 'one' } }
        expect(model).to_not have_scope(:grouped).group('two')
      end
    end

    context 'with a having value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :had, -> { having 'COUNT(*) > 1' } }
        expect(model).to have_scope(:had).having('COUNT(*) > 1')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :had, -> { having 'COUNT(*) > 1' } }
        expect(model).to_not have_scope(:had).having('COUNT(*) > 2')
      end
    end

    context 'with an includes value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :joined, -> { includes :company } }
        expect(model).to have_scope(:joined).includes(:company)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :joined, -> { includes :company } }
        expect(model).to_not have_scope(:joined).includes(:address)
      end
    end

    context 'with a joins value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :joined, -> { joins 'INNER JOIN friends' } }
        expect(model).to have_scope(:joined).joins('INNER JOIN friends')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :joined, -> { joins 'INNER JOIN friends' } }
        expect(model).to_not have_scope(:joined).joins('INNER JOIN enemies')
      end
    end

    context 'with a limit value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :limited, -> { limit 10 } }
        expect(model).to have_scope(:limited).limit(10)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :limited, -> { limit 10 } }
        expect(model).to_not have_scope(:limited).limit(15)
      end
    end

    context 'with a lock value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :locked, -> { lock true } }
        expect(model).to have_scope(:locked).lock(true)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :locked, -> { lock true } }
        expect(model).to_not have_scope(:locked).lock(false)
      end
    end

    context 'with an offset value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :shifted, -> { offset 10 } }
        expect(model).to have_scope(:shifted).offset(10)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :shifted, -> { offset 10 } }
        expect(model).to_not have_scope(:shifted).offset(15)
      end
    end

    context 'with an order value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :ordered, -> { order 'one' } }
        expect(model).to have_scope(:ordered).order('one')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :ordered, -> { order 'one' } }
        expect(model).to_not have_scope(:ordered).order('id')
      end
    end

    context 'with a preload value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :preloaded, -> { preload :company } }
        expect(model).to have_scope(:preloaded).preload(:company)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :preloaded, -> { preload :company } }
        expect(model).to_not have_scope(:preloaded).preload(:address)
      end
    end

    context 'with a readonly value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :prepared, -> { readonly false } }
        expect(model).to have_scope(:prepared).readonly(false)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :prepared, -> { readonly false } }
        expect(model).to_not have_scope(:prepared).readonly(true)
      end
    end

    context 'with a reorder value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :reordered, -> { reorder 'one' } }
        expect(model).to have_scope(:reordered).reorder('one')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :reordered, -> { reorder 'one' } }
        expect(model).to_not have_scope(:reordered).reorder('id')
      end
    end

    context 'with a select value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :ones, -> { select 'one' } }
        expect(model).to have_scope(:ones).select('one')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :ones, -> { select 'one' } }
        expect(model).to_not have_scope(:ones).select('id')
      end
    end

    context 'with a where value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { scope :no_one, -> { where one: nil } }
        expect(model).to have_scope(:no_one).where(one: nil)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { scope :no_one, -> { where one: nil } }
        expect(model).to_not have_scope(:no_one).where(one: 1)
      end
    end

    context 'with option :with' do
      it 'matches if the query matches for the given value' do
        model.instance_eval { scope :which_one, ->(one) { where one: one } }
        expect(model).to have_scope(:which_one, with: 1).where(one: 1)
      end

      it 'does not match if the query does not match for the given value' do
        model.instance_eval { scope :which_one, ->(one) { where one: one } }
        expect(model).to_not have_scope(:which_one, with: 2).where(one: 1)
      end
    end
  end
end
