require 'trb1-representable/binding'

module Trb1
  module Representable
    module Hash
      class Binding < Representable::Binding
        def self.build_for(definition)
          return Collection.new(definition) if definition.array?
          new(definition)
        end

        def read(hash, as)
          hash.has_key?(as) ? hash[as] : FragmentNotFound
        end

        def write(hash, fragment, as)
          hash[as] = fragment
        end

        def serialize_method
          :to_hash
        end

        def deserialize_method
          :from_hash
        end

        class Collection < self
          include Trb1::Representable::Binding::Collection
        end
      end
    end
  end
end
