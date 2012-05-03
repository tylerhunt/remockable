require 'spec_helper'

describe :have_many do
  let(:macro) { :has_many }
  let(:options) { [:posts, { :dependent => :destroy }] }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    before do
      create_table(:users) { |table| table.string(:name) }
    end

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        association = matcher.instance_variable_get(:@association)
        with = " with #{matcher.expected.inspect}" if matcher.expected.any?
        matcher.description.should == "have many #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :posts }

      it 'matches if the association exists' do
        model.has_many(*options)
        model.should have_many(*options)
      end

      it 'does not match if the association does not exist' do
        model.should_not have_many(*options)
      end

      it 'does not match if the association is of the wrong type' do
        model.belongs_to(*options)
        model.should_not have_many(*options)
      end
    end

    with_option(:class_name, 'Post', 'Blog')
    with_option(:conditions, { :published => true }, { :published => false })
    with_option(:order, %w(published_at), %w(title))
    with_option(:foreign_key, :post_id, :blog_id)
    with_option(:primary_key, :id, :post_id)
    with_option(:dependent, :destroy, :nullify)
    with_option(:finder_sql, 'SELECT * FROM posts', 'SELECT * FROM blogs')
    with_option(:counter_sql, 'SELECT COUNT(*) FROM posts', 'SELECT COUNT(*) FROM blogs')
    with_option(:include, :comments, :trackbacks)
    with_option(:group, 'comments_count', 'trackbacks_count')
    with_option(:having, 'comments_count > 5', 'trackbacks_count > 5')
    with_option(:limit, 5, 10)
    with_option(:offset, 10, 20)
    with_option(:select, %w(id), %w(title))
    with_option(:as, :postable, :bloggable)
    with_option(:through, :postings, :bloggings)
    with_option(:source, :piece, :work)
    with_option(:source_type, 'Post', 'Blog')
    with_option(:uniq, true, false)
    with_option(:readonly, true, false)
    with_option(:validate, true, false)
    with_option(:autosave, true, false)
    with_option(:inverse_of, :users, :employees)

    with_unsupported_option(:extend, Module.new)
  end
end
