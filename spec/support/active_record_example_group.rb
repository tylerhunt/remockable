module ActiveRecordExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :active_record

    before do
      ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: ':memory:'
      )
    end
  end

  RSpec.configure do |config|
    config.include self, file_path: /spec\/active_record/
  end
end
