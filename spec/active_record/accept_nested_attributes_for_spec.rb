describe :accept_nested_attributes_for do
  let(:macro) { :accepts_nested_attributes_for }
  let(:options) { [:company, { allow_destroy: true }] }

  it_behaves_like 'an Active Record matcher' do
    let(:matcher_name) { :accept_nested_attributes_for }

    let(:model) {
      build_class :User, ActiveRecord::Base do
        belongs_to :company
      end
    }

    subject(:instance) { model.new }

    before do
      create_table :users
    end

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        association = matcher.attribute
        with = " with #{matcher.options.inspect}" if matcher.options.any?

        expect(matcher.description)
          .to eq "accept nested attributes for #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :company }

      it 'matches if the model accepts the nested attributes' do
        model.accepts_nested_attributes_for(*options)
        expect(model).to accept_nested_attributes_for(*options)
      end

      it 'does not match if the model does not accept the nested attributes' do
        expect(model).to_not accept_nested_attributes_for(*options)
      end
    end

    with_option :allow_destroy, true, false
    with_option :limit, 1, 2
    with_option :update_only, true, false

    with_unsupported_option :reject_if, :all_blank
  end
end
