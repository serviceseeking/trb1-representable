lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'trb1-representable/version'

Gem::Specification.new do |spec|
  spec.name        = "trb1-representable"
  spec.version     = Trb1::Representable::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["Nick Sutterer"]
  spec.email       = ["apotonick@gmail.com"]
  spec.homepage    = "https://github.com/apotonick/representable/"
  spec.summary     = %q{Renders and parses JSON/XML/YAML documents from and to Ruby objects. Includes plain properties, collections, nesting, coercion and more.}
  spec.description = spec.summary

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency "trb1-uber", "~> 0.0.15"
  spec.add_dependency "trb1-declarative", "~> 0.0.5"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "test_xml", "0.1.6"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mongoid"
  spec.add_development_dependency "virtus"
  spec.add_development_dependency "json", '>= 1.7.7'

  spec.add_development_dependency "ruby-prof"
end
