require "trb1-uber/delegates"

require "trb1-declarative/schema"

require "trb1-representable/config"
require "trb1-representable/definition"
require "trb1-representable/declarative"
require "trb1-representable/deserializer"
require "trb1-representable/serializer"
require "trb1-representable/binding"
require "trb1-representable/pipeline"
require "trb1-representable/insert" # Pipeline::Insert
require "trb1-representable/cached"
require "trb1-representable/for_collection"
require "trb1-representable/represent"

module Trb1
  module Representable
    attr_writer :representable_attrs

    def self.included(base)
      base.class_eval do
        extend Declarative
        # make Representable horizontally and vertically inheritable.
        extend ModuleExtensions, ::Trb1::Declarative::Heritage::Inherited, ::Trb1::Declarative::Heritage::Included
        extend ClassMethods
        extend ForCollection
        extend Represent
      end
    end

  private
    # Reads values from +doc+ and sets properties accordingly.
    def update_properties_from(doc, options, format)
      propagated_options = normalize_options(options)

      representable_map!(doc, propagated_options, format, :uncompile_fragment)
      represented
    end

    # Compiles the document going through all properties.
    def create_representation_with(doc, options, format)
      propagated_options = normalize_options(options)

      representable_map!(doc, propagated_options, format, :compile_fragment)
      doc
    end

    class Binding::Map < Array
      def call(method, options)
        each do |bin|
          options[:binding] = bin # this is so much faster than options.merge().
          bin.send(method, options)
        end
      end

       # TODO: Merge with Definitions.
      def <<(binding) # can be slow. this is compile time code.
        (existing = find { |bin| bin.name == binding.name }) ? self[index(existing)] = binding : super(binding)
      end
    end

    def representable_map(options, format)
      Binding::Map.new(representable_bindings_for(format, options))
    end

    def representable_map!(doc, options, format, method)
      options = {doc: doc, options: options, represented: represented, decorator: self}

      representable_map(options, format).(method, options) # .(:uncompile_fragment, options)
    end

    def representable_bindings_for(format, options)
      representable_attrs.collect {|definition| format.build(definition) }
    end

    def normalize_options(options)
      return options if options.any?
      {user_options: {}}.merge(options) # TODO: use keyword args once we drop 2.0.
    end

    # Prepares options for a particular nested representer.
    # This is used in Serializer and Deserializer.
    OptionsForNested = ->(options, binding) do
      child_options = {user_options: options[:user_options], }

      # wrap:
      child_options[:wrap] = binding[:wrap] unless binding[:wrap].nil?

      # nested params:
      child_options.merge!(options[binding.name.to_sym]) if options[binding.name.to_sym]
      child_options
    end

    def representable_attrs
      @representable_attrs ||= self.class.definitions
    end

    def representation_wrap(*args)
      representable_attrs.wrap_for(represented, *args)
    end

    def represented
      self
    end

    module ModuleExtensions
      # Copies the representable_attrs reference to the extended object.
      # Note that changing attrs in the instance will affect the class configuration.
      def extended(object)
        super
        object.representable_attrs=(representable_attrs) # yes, we want a hard overwrite here and no inheritance.
      end
    end

    module ClassMethods
      def prepare(represented)
        represented.extend(self)
      end
    end

    # require "representable/deprecations"
  end

  require 'trb1-representable/autoload'
end
