require 'trb1-representable/hash'
require 'trb1-representable/yaml/binding'

module Trb1
  module Representable
    module YAML
      include Hash

      def self.included(base)
        base.class_eval do
          include Representable
          register_feature Trb1::Representable::YAML
          extend ClassMethods
        end
      end

      module ClassMethods
        def format_engine
          Trb1::Representable::YAML
        end
      end

      def from_yaml(doc, options={})
        hash = Psych.load(doc)
        from_hash(hash, options, Binding)
      end

      # Returns a Nokogiri::XML object representing this object.
      def to_ast(options={})
        Psych::Nodes::Mapping.new.tap do |map|
          create_representation_with(map, options, Binding)
        end
      end

      def to_yaml(*args)
        stream = Psych::Nodes::Stream.new
        stream.children << doc = Psych::Nodes::Document.new

        doc.children << to_ast(*args)
        stream.to_yaml
      end
    end
  end
end
