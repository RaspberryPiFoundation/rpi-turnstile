# frozen_string_literal: true

require_relative 'lib/rpi_turnstile/version'

Gem::Specification.new do |spec|
  spec.name        = 'rpi_turnstile'
  spec.version     = RpiTurnstile::VERSION
  spec.authors     = ['Raspberry Pi Foundation']
  spec.email       = ['web@raspberrypi.org']
  spec.homepage    = 'https://github.com/RaspberryPiFoundation/rpi-turnstile'
  spec.license     = 'MIT'
  spec.summary     = 'Auth via Hydra'
  spec.description = 'Auth via Hydra'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/RaspberryPiFoundation/rpi-turnstile'
  spec.metadata['changelog_uri'] = 'https://github.com/RaspberryPiFoundation/rpi-turnstile/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.required_ruby_version = '>= 3.1.0'

  spec.add_dependency 'faraday'
  spec.add_dependency 'importmap-rails'
  spec.add_dependency 'rails', '>= 7.0.6'
  spec.add_dependency 'stimulus-rails'
  spec.add_dependency 'view_component', '>= 2.0.0'
end
