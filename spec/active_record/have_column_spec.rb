require 'spec_helper'

describe :have_column do
  let(:options) { :one }

  it_behaves_like 'an Active Record matcher' do
    let(:model) { build_class(:User, ActiveRecord::Base) }

    before(:each) do
      create_table(:users) do |table|
      end
    end

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        name = matcher.instance_variable_get(:@name).to_s.gsub(/_/, ' ')
        with = " with #{matcher.expected}" if matcher.expected.any?

        matcher.description.should == "#{name} #{options}#{with}"
      end
    end

    context 'with a column' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column(:users, :one, :string)
        model.should have_column(:one)
      end

      it "doesn't match if the column doesn't exist" do
        model.should_not have_column(:one)
      end
    end

    context 'with option :default' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column(:users, :one, :integer, :default => 1)
        model.should have_column(:one, :default => 1)
      end

      it "doesn't match if the column doesn't have the same default" do
        ActiveRecord::Base.connection.add_column(:users, :one, :integer, :default => 2)
        model.should_not have_column(:one, :default => 1)
      end
    end

    context 'with option :limit' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column(:users, :one, :string, :limit => 10)
        model.should have_column(:one, :limit => 10)
      end

      it "doesn't match if the column doesn't have the same limit" do
        ActiveRecord::Base.connection.add_column(:users, :one, :string, :limit => 5)
        model.should_not have_column(:one, :limit => 10)
      end
    end

    context 'with option :null' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column(:users, :one, :integer, :null => false, :default => 1)
        model.should have_column(:one, :null => false)
      end

      it "doesn't match if the column doesn't have the same null" do
        ActiveRecord::Base.connection.add_column(:users, :one, :integer)
        model.should_not have_column(:one, :null => false)
      end
    end

    context 'with option :precision' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column(:users, :one, :decimal, :precision => 8)
        model.should have_column(:one, :precision => 8)
      end

      it "doesn't match if the column doesn't have the same null" do
        ActiveRecord::Base.connection.add_column(:users, :one, :decimal, :precision => 8)
        model.should_not have_column(:one, :precision => 5)
      end
    end

    context 'with option :scale' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column(:users, :one, :decimal, :precision => 8, :scale => 2)
        model.should have_column(:one, :scale => 2)
      end

      it "doesn't match if the column doesn't have the same null" do
        ActiveRecord::Base.connection.add_column(:users, :one, :decimal, :precision => 8, :scale => 2)
        model.should_not have_column(:one, :scale => 3)
      end
    end

    context 'with option :type' do
      it 'matches if the column exists' do
        ActiveRecord::Base.connection.add_column(:users, :one, :integer)
        model.should have_column(:one, :type => :integer)
      end

      it "doesn't match if the column doesn't have the same type" do
        ActiveRecord::Base.connection.add_column(:users, :one, :string)
        model.should_not have_column(:one, :type => :integer)
      end
    end
  end
end
