# frozen_string_literal: true

require_relative 'lib/rpi_turnstile/version'

Gem::Specification.new do |spec|
  spec.name        = 'rpi_turnstile'
  spec.version     = RpiTurnstile::VERSION
  spec.authors     = ['Raspberry Pi Foundation']
  spec.email       = ['web@raspberrypi.org']
  spec.homepage    = 'https://github.com/RaspberryPiFoundation/rpi-turnstile'
  spec.license     = 'MIT'
  spec.summary     = 'Rails integration for Cloudflare Turnstile'
  spec.description = 'Uses ViewComponent and Stimulus controller for simple
  inclusion of with Cloudflare Turnstile in your app.'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/RaspberryPiFoundation/rpi-turnstile'
  spec.metadata['changelog_uri'] = 'https://github.com/RaspberryPiFoundation/rpi-turnstile/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['{app,config,lib}/**/*', 'LICENSE', 'README.md']

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'faraday'
  spec.add_dependency 'importmap-rails'
end
