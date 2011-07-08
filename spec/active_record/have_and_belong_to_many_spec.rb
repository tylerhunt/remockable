require 'spec_helper'

describe :have_and_belong_to_many do
  let(:macro) { :has_and_belongs_to_many }
  let(:options) { [:tags, :order => :name] }

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
        matcher.description.should == "have and belong to #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :tags }

      it 'matches if the association exists' do
        model.has_and_belongs_to_many(*options)
        model.should have_and_belong_to_many(*options)
      end

      it "doesn't match if the association doesn't exist" do
        model.should_not have_and_belong_to_many(*options)
      end

      it "doesn't match if the association is of the wrong type" do
        model.has_many(*options)
        model.should_not have_and_belong_to_many(*options)
      end
    end

    with_option(:class_name, 'Tag', 'Role')
    with_option(:join_table, 'tags_users', 'user_tags')
    with_option(:foreign_key, :user_id, :tagged_id)
    with_option(:association_foreign_key, :tag_id, :role_id)
    with_option(:conditions, { :active => true }, { :active => false })
    with_option(:order, :name, :created_at)
    with_option(:uniq, true, false)
    with_option(:finder_sql, 'SELECT * FROM user_tags', 'SELECT * FROM tags_users')
    with_option(:counter_sql, 'SELECT COUNT(*) FROM user_tags', 'SELECT COUNT(*) FROM tags_users')
    with_option(:delete_sql, 'DELETE FROM user_tags', 'DELETE FROM tags_users')
    with_option(:insert_sql, 'INSERT INTO user_tags', 'INSERT INTO tags_users')
    with_option(:include, :statistics, :changes)
    with_option(:group, 'usage_count', 'changes_count')
    with_option(:having, 'usage_count > 5', 'changes_count > 5')
    with_option(:limit, 5, 10)
    with_option(:offset, 10, 20)
    with_option(:select, %w(id), %w(name))
    with_option(:readonly, true, false)
    with_option(:validate, true, false)
    with_option(:autosave, true, false)

    with_unsupported_option(:extend, Module.new)
  end
end
