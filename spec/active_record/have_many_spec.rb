describe :have_many do
  let(:macro) { :has_many }
  let(:options) { [:posts, { dependent: :destroy }] }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    subject(:instance) { model.new }

    before do
      create_table(:users) { |table| table.string(:name) }
    end

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        association = matcher.attribute
        with = " with #{matcher.options.inspect}" if matcher.options.any?

        expect(matcher.description).to eq "have many #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :posts }

      it 'matches if the association exists' do
        model.has_many(*options)
        expect(model).to have_many(*options)
      end

      it 'does not match if the association does not exist' do
        expect(model).to_not have_many(*options)
      end

      it 'does not match if the association is of the wrong type' do
        model.belongs_to(*options)
        expect(model).to_not have_many(*options)
      end
    end

    with_option(:class_name, 'Post', 'Blog')
    with_option(:foreign_key, :post_id, :blog_id)
    with_option(:primary_key, :id, :post_id)
    with_option(:dependent, :destroy, :nullify)
    with_option(:counter_cache, :post_count, :posts_count)
    with_option(:as, :postable, :bloggable)
    with_option(:through, :postings, :bloggings)
    with_option(:source, :piece, :work, through: :postings)
    with_option(:source_type, 'Post', 'Blog', through: :postings)
    with_option(:validate, true, false)
    with_option(:autosave, true, false)
    with_option(:inverse_of, :users, :employees)
  end
end
