require 'trb1-representable/json'
require 'trb1-representable/hash_methods'

module Trb1::Representable::JSON
  # "Lonely Hash" support.
  module Hash
    def self.included(base)
      base.class_eval do
        include Representable
        extend ClassMethods
        include Trb1::Representable::JSON
        include Trb1::Representable::HashMethods
        property(:_self, hash: true)
      end
    end


    module ClassMethods
      def values(options, &block)
        hash(:_self, options, &block)
      end
    end
  end
end
