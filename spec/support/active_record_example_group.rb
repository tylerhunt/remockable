module ActiveRecordExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :active_record

    let(:rake) { Rake::Application.new }
    let(:task) { rake[self.class.description] }
    let(:namespace) { self.class.description.split(':').first }

    before(:all) do
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => ':memory:'
      )
    end
  end

  RSpec.configure do |config|
    config.include self, :example_group => { :file_path => /spec\/active_record/ }
  end
end
