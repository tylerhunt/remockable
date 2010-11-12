module ClassBuilder
  def build_class(name, &block)
    Class.new do
      class_eval <<-EVAL
        def self.name
          '#{name}'
        end
      EVAL

      class_eval(&block)
    end
  end
end

RSpec.configure do |config|
  config.include(ClassBuilder)
end
