# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snippet_highlight/version'

Gem::Specification.new do |spec|
  spec.name          = "snippet_highlight"
  spec.version       = SnippetHighlight::VERSION
  spec.authors       = ["James Silberbauer"]
  spec.email         = ["jamessil@telkomsa.net"]

  spec.summary       = %q{Highlight a snippet of code.}
  spec.description   = %q{Select a snippet of text. Run this program and paste the highlighted result with middle mouse button.}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rouge"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
