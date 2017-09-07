describe :have_and_belong_to_many do
  let(:macro) { :has_and_belongs_to_many }
  let(:options) { [:tags, { validate: true }] }

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
        association = matcher.attribute
        with = " with #{matcher.options.inspect}" if matcher.options.any?

        expect(matcher.description)
          .to eq "have and belong to #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :tags }

      it 'matches if the association exists' do
        model.has_and_belongs_to_many(*options)
        expect(model).to have_and_belong_to_many(*options)
      end

      it 'does not match if the association does not exist' do
        expect(model).to_not have_and_belong_to_many(*options)
      end

      it 'does not match if the association is of the wrong type' do
        model.has_many(*options)
        expect(model).to_not have_and_belong_to_many(*options)
      end
    end

    with_option :class_name, 'Tag', 'Role'
    with_option :join_table, 'tags_users', 'user_tags'
    with_option :foreign_key, :user_id, :tagged_id
    with_option :association_foreign_key, :tag_id, :role_id
    with_option :validate, true, false
    with_option :autosave, true, false
  end
end
