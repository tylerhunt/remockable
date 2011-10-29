require 'spec_helper'

describe :accept_nested_attributes_for do
  let(:options) { [:posts, :allow_destroy => true] }

  it_behaves_like 'an Active Record matcher' do
    let(:model) do
      build_class(:User, ActiveRecord::Base) do
        has_many :posts
      end
    end

    before(:each) { create_table(:users) }

    subject { model.new }

    context 'description' do
      let(:matcher) { send(matcher_name, *options) }

      it 'has a custom description' do
        association = matcher.instance_variable_get(:@association)
        with = " with #{matcher.expected}" if matcher.expected.any?
        matcher.description.should == "accept nested attributes for #{association}#{with}"
      end
    end

    context 'with no options' do
      let(:options) { :posts }

      it 'matches if the model accepts the nested attributes' do
        model.accepts_nested_attributes_for(*options)
        model.should accept_nested_attributes_for(*options)
      end

      it "doesn't match if the model doesn't accept the nested attributes" do
        model.should_not accept_nested_attributes_for(*options)
      end
    end

    context 'with option :allow_destroy' do
      it 'matches if the options match' do
        model.accepts_nested_attributes_for(:posts, :allow_destroy => true)
        model.should_not accept_nested_attributes_for(:loaded, :allow_destroy => true)
      end

      it "doesn't match if the options don't match" do
        model.accepts_nested_attributes_for(:posts, :allow_destroy => false)
        model.should_not accept_nested_attributes_for(:loaded, :allow_destroy => true)
      end
    end

    context 'with option :limit' do
      it 'matches if the options match' do
        model.accepts_nested_attributes_for(:posts, :limit => 1)
        model.should_not accept_nested_attributes_for(:loaded, :limit => 1)
      end

      it "doesn't match if the options don't match" do
        model.accepts_nested_attributes_for(:posts, :limit => 2)
        model.should_not accept_nested_attributes_for(:loaded, :limit => 1)
      end
    end

    context 'with option :update_only' do
      it 'matches if the options match' do
        model.accepts_nested_attributes_for(:posts, :update_only => true)
        model.should_not accept_nested_attributes_for(:loaded, :update_only => true)
      end

      it "doesn't match if the options don't match" do
        model.accepts_nested_attributes_for(:posts, :update_only => false)
        model.should_not accept_nested_attributes_for(:loaded, :update_only => true)
      end
    end
  end
end
