module Trb1::Representable::XML
  module Collection
    def self.included(base)
      base.send :include, Trb1::Representable::XML
      base.send :include, Trb1::Representable::Hash::Collection
      base.send :include, Methods
    end

    module Methods
      def create_representation_with(doc, options, format)
        bin = representable_map(options, format).first
        bin.write(doc, super, bin.name)
      end

      def update_properties_from(doc, *args)
        super(doc.search("./*"), *args) # pass the list of collection items to Hash::Collection#update_properties_from.
      end
    end
  end
end
