require 'active_support/concern'

require 'remockable/helpers'

module Remockable
  module ActiveRecord
    module Helpers
      extend ActiveSupport::Concern
      include Remockable::Helpers
    end
  end
end
