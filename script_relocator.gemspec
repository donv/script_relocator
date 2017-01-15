# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'script_relocator/version'

Gem::Specification.new do |spec|
  spec.name          = 'script_relocator'
  spec.version       = ScriptRelocator::VERSION
  spec.licenses    = ['MIT']
  spec.authors       = ['Uwe Kubosch']
  spec.email         = ['uwe@kubosch.no']

  spec.summary       = %q{Rack middleware to relocate JavaScript tags to the end of an HTML response body.}
  spec.description   = %Q{Rack middleware to relocate JavaScript tags to the end of an HTML response body.\nOnly handles non-streaming `text/html` reponses.}
  spec.homepage      = 'https://github.com/donv/script_relocator'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
end
