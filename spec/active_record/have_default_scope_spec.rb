require 'spec_helper'

describe :have_default_scope do
  let(:options) { :one }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    before do
      create_table(:users) { |table| table.string(:one) }
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
        model.instance_eval { default_scope(-> { order(:id) }) }
        model.should have_default_scope
      end

      it 'does not match if a default scope does not exist' do
        model.should_not have_default_scope
      end
    end

    context 'with a from value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { from('users') }) }
        model.should have_default_scope.from('users')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { from('users') }) }
        model.should_not have_default_scope.from('friends')
      end
    end

    context 'with a group value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { group('one') }) }
        model.should have_default_scope.group('one')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { group('one') }) }
        model.should_not have_default_scope.group('two')
      end
    end

    context 'with a having value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { having('COUNT(*) > 1') }) }
        model.should have_default_scope.having('COUNT(*) > 1')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { having('COUNT(*) > 1') }) }
        model.should_not have_default_scope.having('COUNT(*) > 2')
      end
    end

    context 'with a having value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { having('COUNT(*) > 1') }) }
        model.should have_default_scope.having('COUNT(*) > 1')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { having('COUNT(*) > 1') }) }
        model.should_not have_default_scope.having('COUNT(*) > 2')
      end
    end

    context 'with a joins value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { joins('INNER JOIN friends') }) }
        model.should have_default_scope.joins('INNER JOIN friends')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { joins('INNER JOIN friends') }) }
        model.should_not have_default_scope.joins('INNER JOIN enemies')
      end
    end

    context 'with a limit value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { limit(10) }) }
        model.should have_default_scope.limit(10)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { limit(10) }) }
        model.should_not have_default_scope.limit(15)
      end
    end

    context 'with an offset value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { offset(10) }) }
        model.should have_default_scope.offset(10)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { offset(10) }) }
        model.should_not have_default_scope.offset(15)
      end
    end

    context 'with an order value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { order('one') }) }
        model.should have_default_scope.order('one')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { order('one') }) }
        model.should_not have_default_scope.order('id')
      end
    end

    context 'with a reorder value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { reorder('one') }) }
        model.should have_default_scope.reorder('one')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { reorder('one') }) }
        model.should_not have_default_scope.reorder('id')
      end
    end

    context 'with a select value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { select('one') }) }
        model.should have_default_scope.select('one')
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { select('one') }) }
        model.should_not have_default_scope.select('id')
      end
    end

    context 'with a where value' do
      it 'matches if the scope exists and the query matches' do
        model.instance_eval { default_scope(-> { where(:one => nil) }) }
        model.should have_default_scope.where(:one => nil)
      end

      it 'does not match if the query does not match' do
        model.instance_eval { default_scope(-> { where(:one => nil) }) }
        model.should_not have_default_scope.where(:one => 1)
      end
    end
  end
end
