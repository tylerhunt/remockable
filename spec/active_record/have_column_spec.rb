describe :have_column do
  let(:options) { :one }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    subject(:instance) { model.new }

    before do
      create_table :users
    end

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        with = " with #{matcher.options}" if matcher.options.any?

        expect(matcher.description).to eq "have column #{options}#{with}"
      end
    end

    context 'with a column' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column :users, :one, :string
        expect(model).to have_column :one
      end

      it 'does not match if the column does not exist' do
        expect(model).to_not have_column :one
      end
    end

    context 'with option :default' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column :users, :one, :integer, default: 1
        expect(model).to have_column :one, default: 1
      end

      it 'does not match if the column does not have the same default' do
        ActiveRecord::Base.connection.add_column :users, :one, :integer, default: 2
        expect(model).to_not have_column :one, default: 1
      end
    end

    context 'with option :limit' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column :users, :one, :string, limit: 10
        expect(model).to have_column :one, limit: 10
      end

      it 'does not match if the column does not have the same limit' do
        ActiveRecord::Base.connection.add_column :users, :one, :string, limit: 5
        expect(model).to_not have_column :one, limit: 10
      end
    end

    context 'with option :null' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column :users, :one, :integer, null: false, default: 1
        expect(model).to have_column :one, null: false
      end

      it 'does not match if the column does not have the same null' do
        ActiveRecord::Base.connection.add_column :users, :one, :integer
        expect(model).to_not have_column :one, null: false
      end
    end

    context 'with option :precision' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column :users, :one, :decimal, precision: 8
        expect(model).to have_column :one, precision: 8
      end

      it 'does not match if the column does not have the same null' do
        ActiveRecord::Base.connection.add_column :users, :one, :decimal, precision: 8
        expect(model).to_not have_column :one, precision: 5
      end
    end

    context 'with option :scale' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column :users, :one, :decimal, precision: 8, scale: 2
        expect(model).to have_column :one, scale: 2
      end

      it 'does not match if the column does not have the same null' do
        ActiveRecord::Base.connection.add_column :users, :one, :decimal, precision: 8, scale: 2
        expect(model).to_not have_column :one, scale: 3
      end
    end

    context 'with option :type' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column :users, :one, :integer
        expect(model).to have_column :one, type: :integer
      end

      it 'does not match if the column does not have the same type' do
        ActiveRecord::Base.connection.add_column :users, :one, :string
        expect(model).to_not have_column :one, type: :integer
      end
    end
  end
end
