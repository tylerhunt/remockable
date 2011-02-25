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

    subject { model }

    context "with a single column" do
      it "matches if the index exists" do
        ActiveRecord::Base.connection.add_index(:users, :one)
        model.should have_index(:one).should be_true
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index(:one).should be_true
      end
    end

    context "with multiple columns" do
      it "matches if the index exists" do
        ActiveRecord::Base.connection.add_index(:users, [:one, :two])
        model.should have_index([:one, :two]).should be_true
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index([:one, :two]).should be_true
      end
    end

    context "with option :unique" do
      it "matches if the index exists" do
        ActiveRecord::Base.connection.add_index(:users, :one, :unique => true)
        model.should have_index(:one, :unique => true).should be_true
      end

      it "doesn't match if the index isn't unique" do
        ActiveRecord::Base.connection.add_index(:users, :one)
        model.should_not have_index(:one, :unique => true).should be_true
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index(:one, :unique => true).should be_true
      end
    end

    context "with option :name" do
      it "matches if the index exists" do
        ActiveRecord::Base.connection.add_index(:users, :one, :name => :oneness)
        model.should have_index(:one, :name => :oneness).should be_true
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index(:one, :name => :oneness).should be_true
      end
    end

    context "with option :name and without :one" do
      it "matches if the index exists" do
        ActiveRecord::Base.connection.add_index(:users, :one, :name => :oneness)
        model.should have_index(:name => :oneness).should be_true
      end

      it "doesn't match if the index doesn't exist" do
        model.should_not have_index(:name => :oneness).should be_true
      end
    end
  end
end
