require 'spec_helper'

describe :have_default_scope do
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

        matcher.description.should == "have a default scope#{with}"
      end
    end

    context 'without arguments' do
      it 'matches if a default scope exists' do
        model.instance_eval { default_scope(order(:id)) }
        model.should have_default_scope
      end

      it "doesn't match if a default scope doesn't exist" do
        model.should_not have_default_scope
      end
    end

    context 'with an eager_load value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(eager_load(:order)) }
        model.should have_default_scope.eager_load(:order)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(eager_load(:order)) }
        model.should_not have_default_scope.eager_load(:from)
      end
    end

    context 'with a from value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(from('users')) }
        model.should have_default_scope.from('users')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(from('users')) }
        model.should_not have_default_scope.from('friends')
      end
    end

    context 'with a group value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(group('one')) }
        model.should have_default_scope.group('one')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(group('one')) }
        model.should_not have_default_scope.group('two')
      end
    end

    context 'with a having value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(having('COUNT(*) > 1')) }
        model.should have_default_scope.having('COUNT(*) > 1')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(having('COUNT(*) > 1')) }
        model.should_not have_default_scope.having('COUNT(*) > 2')
      end
    end

    context 'with a having value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(having('COUNT(*) > 1')) }
        model.should have_default_scope.having('COUNT(*) > 1')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(having('COUNT(*) > 1')) }
        model.should_not have_default_scope.having('COUNT(*) > 2')
      end
    end

    context 'with an includes value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(includes(:company)) }
        model.should have_default_scope.includes(:company)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(includes(:company)) }
        model.should_not have_default_scope.includes(:address)
      end
    end

    context 'with a joins value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(joins('INNER JOIN friends')) }
        model.should have_default_scope.joins('INNER JOIN friends')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(joins('INNER JOIN friends')) }
        model.should_not have_default_scope.joins('INNER JOIN enemies')
      end
    end

    context 'with a limit value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(limit(10)) }
        model.should have_default_scope.limit(10)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(limit(10)) }
        model.should_not have_default_scope.limit(15)
      end
    end

    context 'with a lock value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(lock(true)) }
        model.should have_default_scope.lock(true)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(lock(true)) }
        model.should_not have_default_scope.lock(false)
      end
    end

    context 'with an offset value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(offset(10)) }
        model.should have_default_scope.offset(10)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(offset(10)) }
        model.should_not have_default_scope.offset(15)
      end
    end

    context 'with an order value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(order('one')) }
        model.should have_default_scope.order('one')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(order('one')) }
        model.should_not have_default_scope.order('id')
      end
    end

    context 'with a preload value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(preload(:company)) }
        model.should have_default_scope.preload(:company)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(preload(:company)) }
        model.should_not have_default_scope.preload(:address)
      end
    end

    context 'with a readonly value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(readonly(false)) }
        model.should have_default_scope.readonly(false)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(readonly(false)) }
        model.should_not have_default_scope.readonly(true)
      end
    end

    context 'with a reorder value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(reorder('one')) }
        model.should have_default_scope.reorder('one')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(reorder('one')) }
        model.should_not have_default_scope.reorder('id')
      end
    end

    context 'with a select value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(select('one')) }
        model.should have_default_scope.select('one')
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(select('one')) }
        model.should_not have_default_scope.select('id')
      end
    end

    context 'with a where value' do
      it 'matches if the scope exists and the definition matches' do
        model.instance_eval { default_scope(where(:one => nil)) }
        model.should have_default_scope.where(:one => nil)
      end

      it "doesn't match if the definition doesn't match" do
        model.instance_eval { default_scope(where(:one => nil)) }
        model.should_not have_default_scope.where(:one => 1)
      end
    end
  end
end
