module ClassBuilder
  def build_class(name, superclass=Object, &block)
    Class.new(superclass) do
      class_eval <<-EVAL
        def self.name
          '#{name}'
        end
      EVAL

      class_eval(&block) if block_given?
    end
  end

  def create_table(table_name, options={}, &block)
    begin
      drop_table(table_name)
      ActiveRecord::Base.connection.create_table(table_name, options, &block)
      (@created_tables ||= []) << table_name
    rescue
      drop_table(table_name)
      raise $!
    end
  end

  def drop_table(table_name)
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{table_name}")
  end

  def drop_created_tables
    if @created_tables
      @created_tables.each { |table_name| drop_table(table_name) }
    end
  end
end

RSpec.configure do |config|
  config.include(ClassBuilder)
  config.after { drop_created_tables }
end
