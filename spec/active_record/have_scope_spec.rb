require 'spec_helper'

describe :have_scope do
  let(:options) { :one }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    before(:each) do
      create_table(:users) do |table|
        table.string :one
      end
    end

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
        with = " with #{matcher.expected}" if matcher.expected.any?

        matcher.description.should == "have scope #{name}#{with}"
      end
    end

    context 'with a scope name' do
      it 'matches if the scope exists' do
        model.instance_eval { scope(:no_one, where(:one => nil)) }
        model.should have_scope(:no_one)
      end

      it "doesn't match if the scope doesn't exist" do
        model.should_not have_scope(:no_one)
      end
    end

    context 'with an eager_load value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:loaded, eager_load(:order)) }
        model.should have_scope(:loaded).eager_load(:order)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:loaded, eager_load(:order)) }
        model.should_not have_scope(:loaded).eager_load(:from)
      end
    end

    context 'with a from value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:haved, from('users')) }
        model.should have_scope(:haved).from('users')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:haved, from('users')) }
        model.should_not have_scope(:haved).from('friends')
      end
    end

    context 'with a group value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:haved, group('one')) }
        model.should have_scope(:haved).group('one')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:haved, group('one')) }
        model.should_not have_scope(:haved).group('two')
      end
    end

    context 'with a having value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:haved, having('COUNT(*) > 1')) }
        model.should have_scope(:haved).having('COUNT(*) > 1')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:haved, having('COUNT(*) > 1')) }
        model.should_not have_scope(:haved).having('COUNT(*) > 2')
      end
    end

    context 'with a having value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:has, having('COUNT(*) > 1')) }
        model.should have_scope(:has).having('COUNT(*) > 1')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:has, having('COUNT(*) > 1')) }
        model.should_not have_scope(:has).having('COUNT(*) > 2')
      end
    end

    context 'with an includes value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:joined, includes(:company)) }
        model.should have_scope(:joined).includes(:company)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:joined, includes(:company)) }
        model.should_not have_scope(:joined).includes(:address)
      end
    end

    context 'with a joins value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:joined, joins('INNER JOIN friends')) }
        model.should have_scope(:joined).joins('INNER JOIN friends')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:joined, joins('INNER JOIN friends')) }
        model.should_not have_scope(:joined).joins('INNER JOIN enemies')
      end
    end

    context 'with a limit value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:limited, limit(10)) }
        model.should have_scope(:limited).limit(10)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:limited, limit(10)) }
        model.should_not have_scope(:limited).limit(15)
      end
    end

    context 'with a lock value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:locked, lock(true)) }
        model.should have_scope(:locked).lock(true)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:locked, lock(true)) }
        model.should_not have_scope(:locked).lock(false)
      end
    end

    context 'with an offset value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:shifted, offset(10)) }
        model.should have_scope(:shifted).offset(10)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:shifted, offset(10)) }
        model.should_not have_scope(:shifted).offset(15)
      end
    end

    context 'with an order value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:ordered, order('one')) }
        model.should have_scope(:ordered).order('one')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:ordered, order('one')) }
        model.should_not have_scope(:ordered).order('id')
      end
    end

    context 'with a preload value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:preloaded, preload(:company)) }
        model.should have_scope(:preloaded).preload(:company)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:preloaded, preload(:company)) }
        model.should_not have_scope(:preloaded).preload(:address)
      end
    end

    context 'with a readonly value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:prepared, readonly(false)) }
        model.should have_scope(:prepared).readonly(false)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:prepared, readonly(false)) }
        model.should_not have_scope(:prepared).readonly(true)
      end
    end

    context 'with a reorder value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:reordered, reorder('one')) }
        model.should have_scope(:reordered).reorder('one')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:reordered, reorder('one')) }
        model.should_not have_scope(:reordered).reorder('id')
      end
    end

    context 'with a select value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:ones, select('one')) }
        model.should have_scope(:ones).select('one')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:ones, select('one')) }
        model.should_not have_scope(:ones).select('id')
      end
    end

    context 'with a where value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { scope(:no_one, where(:one => nil)) }
        model.should have_scope(:no_one).where(:one => nil)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { scope(:no_one, where(:one => nil)) }
        model.should_not have_scope(:no_one).where(:one => 1)
      end
    end

    context 'with option :with' do
      it 'matches if the definition matches for the given value' do
        model.instance_eval { scope(:which_one, lambda { |one| where(:one => one) }) }
        model.should have_scope(:which_one, :with => 1).where(:one => 1)
      end

      it "doesn't match if the definition doesn't match for the given value" do
        model.instance_eval { scope(:which_one, lambda { |one| where(:one => one) }) }
        model.should_not have_scope(:which_one, :with => 2).where(:one => 1)
      end
    end
  end
end
