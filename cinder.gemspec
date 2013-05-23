# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'cinder/version'

Gem::Specification.new do |s|
  s.name          = "cinder"
  s.version       = Cinder::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Tim Taylor", "Nate West"]
  s.email         = ["tim@detroitlabs.com", "nwest@detroitlabs.com"]
  s.summary       = "Continuous Delivery for iOS Apps"
  s.homepage      = "https://github.com/CinderCI/cinder"
  s.license       = "MIT"
  s.description   = <<desc
Cinder does the heavy lifting for building and distributing 
iOS applications in a continuous integration environment.
desc

  s.requirements  << 'Xcode Command Line Tools'

  s.add_dependency "commander", "~> 4.1.3"
  s.add_dependency "extlib", "~> 0.9.16"
  s.add_dependency "plist", "~> 3.1.0"
  s.add_dependency "dotenv", "~> 0.7.0"
  s.add_dependency "cocoapods", "~> 0.20.0"
  s.add_dependency "shenzhen", "~> 0.3.1"
  s.add_dependency "rugged", "~> 0.16.0"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakefs', '~> 0.4.2'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
