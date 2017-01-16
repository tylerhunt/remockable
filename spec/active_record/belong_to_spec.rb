describe :belong_to do
  let(:macro) { :belongs_to }
  let(:options) { [:company, { dependent: :destroy }] }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    subject(:instance) { model.new }

    before do
      create_table :users do |table|
        table.integer :company_id
      end
    end

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        association = matcher.attribute
        with = " with #{matcher.options.inspect}" if matcher.options.any?

        expect(matcher.description).to eq "belong to #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :company }

      it 'matches if the association exists' do
        model.belongs_to *options
        expect(model).to belong_to *options
      end

      it 'does not match if the association does not exist' do
        expect(model).to_not belong_to *options
      end

      it 'does not match if the association is of the wrong type' do
        model.has_many *options
        expect(model).to_not belong_to *options
      end
    end

    with_option :class_name, 'Company', 'Organization'
    with_option :foreign_key, :company_id, :organization_id
    with_option :foreign_type, :company_type, :organization_type
    with_option :primary_key, :id, :company_id
    with_option :dependent, :destroy, :nullify
    with_option :counter_cache, true, false
    with_option :polymorphic, true, false
    with_option :validate, true, false
    with_option :autosave, true, false
    with_option :touch, true, false
    with_option :inverse_of, :users, :employees

    if ActiveRecord.version > Gem::Version.new('5.0')
      with_option :optional, true, false
    else
      with_option :required, true, false
    end
  end
end
