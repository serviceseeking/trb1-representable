module Trb1
  module Representable::JSON
    module Collection
      include Trb1::Representable::JSON

      def self.included(base)
        base.send :include, Trb1::Representable::Hash::Collection
      end
    end
  end
end
