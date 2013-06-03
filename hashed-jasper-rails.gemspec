# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hashed-jasper-rails/version'

Gem::Specification.new do |s|
  s.name = 'hashed-jasper-rails'
  s.version = HashedJasperRails::VERSION
  s.authors = ['Yamamoto Kazuhisa']
  s.email = 'ak.hisashi@gmail.com'
  s.description = 'Generate pdf reports on Rails using Jasper Reports reporting tool.'
  s.summary = 'Report tool'
  s.homepage = 'http://github.com/kazuhisa/hashed-jasper-rails'
  s.licenses = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'rspec', '~> 2.13'
  s.add_development_dependency 'rspec-rails'
  s.add_dependency 'rails', '>= 3.0.7'
  s.add_dependency 'jasper-rails', '>= 1.0.3'
end

