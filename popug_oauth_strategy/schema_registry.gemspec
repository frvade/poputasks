# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name         = 'popug_oauth_strategy'
  spec.authors       = ['Lev Bro']
  spec.summary      = 'Popug auth strategy for oauth2'
  spec.version      = 1
  spec.license      = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = %w[lib/]

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'omniauth-oauth2'
end