require 'active_support/concern'

module Remockable
  module Helpers
    extend ActiveSupport::Concern

    module ClassMethods
      def type(type)
        define_method :type do
          type
        end
      end

      def unsupported_options(keys)
        define_method :unsupported_options do
          keys.collect(&:to_sym)
        end
      end

      def valid_options(keys)
        define_method :valid_options do
          keys.collect(&:to_sym)
        end
      end
    end

    def attribute
      @attribute ||= expected_as_array.first
    end

    def options
      @options ||= expected_as_array.extract_options!
    end

    def matches?(actual)
      validate_options!
      super
    end

    def unsupported_options
      []
    end

    def valid_options
      []
    end

    def validate_options!
      check_unsupported_options!
      check_valid_options!
    end

  private

    def check_unsupported_options!
      options.each_key do |key|
        if unsupported_options.include?(key.to_sym)
          raise ArgumentError.new("Unsupported option #{key.inspect}")
        end
      end
    end

    def check_valid_options!
      options.each_key do |key|
        unless valid_options.include?(key.to_sym)
          raise ArgumentError.new("Unknown option #{key.inspect}")
        end
      end
    end
  end
end
