require 'spec_helper'

describe :have_index do
  let(:options) { :one }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    subject(:instance) { model.new }

    before do
      create_table :users do |table|
        table.string :one
        table.string :two
      end
    end

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        with = " with #{matcher.options}" if matcher.options.any?

        expect(matcher.description).to eq "have index on #{options}#{with}"
      end
    end

    context 'with a single column' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index :users, :one
        expect(model).to have_index :one
      end

      it 'does not match if the index does not exist' do
        expect(model).to_not have_index :one
      end
    end

    context 'with multiple columns' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index :users, [:one, :two]
        expect(model).to have_index [:one, :two]
      end

      it 'does not match if the index does not exist' do
        expect(model).to_not have_index [:one, :two]
      end
    end

    context 'with option :unique' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index :users, :one, unique: true
        expect(model).to have_index :one, unique: true
      end

      it 'does not match if the index is not unique' do
        ActiveRecord::Base.connection.add_index :users, :one
        expect(model).to_not have_index :one, unique: true
      end

      it 'does not match if the index does not exist' do
        expect(model).to_not have_index :one, unique: true
      end
    end

    context 'with option :name' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index :users, :one, name: :oneness
        expect(model).to have_index :one, name: :oneness
      end

      it 'does not match if the index does not exist' do
        expect(model).to_not have_index :one, name: :oneness
      end
    end

    context 'with option :name and without :one' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index :users, :one, name: :oneness
        expect(model).to have_index name: :oneness
      end

      it 'does not match if the index does not exist' do
        expect(model).to_not have_index name: :oneness
      end
    end
  end
end
