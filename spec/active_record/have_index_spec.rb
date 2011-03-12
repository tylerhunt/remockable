require 'spec_helper'

describe :have_index do
  let(:options) { :one }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    before(:each) do
      create_table(:users) do |table|
        table.string :one
        table.string :two
      end
    end

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
        with = " with #{matcher.expected}" if matcher.expected.any?

        matcher.description.should == "#{name} on #{options}#{with}"
      end
    end

    context 'with a single column' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index(:users, :one)
        model.should have_index(:one)
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index(:one)
      end
    end

    context 'with multiple columns' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index(:users, [:one, :two])
        model.should have_index([:one, :two])
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index([:one, :two])
      end
    end

    context 'with option :unique' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index(:users, :one, :unique => true)
        model.should have_index(:one, :unique => true)
      end

      it "doesn't match if the index isn't unique" do
        ActiveRecord::Base.connection.add_index(:users, :one)
        model.should_not have_index(:one, :unique => true)
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index(:one, :unique => true)
      end
    end

    context 'with option :name' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index(:users, :one, :name => :oneness)
        model.should have_index(:one, :name => :oneness)
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index(:one, :name => :oneness)
      end
    end

    context 'with option :name and without :one' do
      it 'matches if the index exists' do
        ActiveRecord::Base.connection.add_index(:users, :one, :name => :oneness)
        model.should have_index(:name => :oneness)
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index(:name => :oneness)
      end
    end
  end
end
