module Trb1
  module Representable
    autoload :Hash, 'trb1-representable/hash'

    module Hash
      autoload :AllowSymbols, 'trb1-representable/hash/allow_symbols'
      autoload :Collection, 'trb1-representable/hash/collection'
    end

    autoload :Decorator, 'trb1-representable/decorator'
  end
end
