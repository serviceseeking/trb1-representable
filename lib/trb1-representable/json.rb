require "trb1-representable/hash"
require "trb1-representable/json/collection"

begin
  require "multi_json"
rescue LoadError => _
  abort "Missing dependency 'multi_json' for Trb1::Representable::JSON. See dependencies section in README.md for details."
end

module Trb1
  module Representable
    # Brings #to_json and #from_json to your object.
    module JSON
      extend Hash::ClassMethods
      include Hash

      def self.included(base)
        base.class_eval do
          include Representable # either in Hero or HeroRepresentation.
          extend ClassMethods # DISCUSS: do that only for classes?
          register_feature Trb1::Representable::JSON
        end
      end


      module ClassMethods
        def format_engine
          Trb1::Representable::Hash
        end

        def collection_representer_class
          Trb1::Representable::JSON::Collection
        end
      end


      # Parses the body as JSON and delegates to #from_hash.
      def from_json(data, *args)
        data = MultiJson.load(data)
        from_hash(data, *args)
      end

      # Returns a JSON string representing this object.
      def to_json(*args)
        MultiJson.dump to_hash(*args)
      end
    end
  end
end
