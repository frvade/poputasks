# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name         = 'schema_registry'
  spec.version      = 1
  spec.authors       = ['Anton Davydov']
  spec.email         = ['antondavydov.o@gmail.com']
  spec.summary      = 'Event schema registry example'
  spec.homepage     = 'https://github.com/davydovanton/event_schema_registry'
  spec.license      = 'MIT'

  spec.files         = Dir['../schemas/**/*', 'lib/**/*']
  spec.require_paths = %w[../schemas lib/]

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_dependency 'json-schema'
end