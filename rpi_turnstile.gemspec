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
  spec.description = 'A ViewComponent wrapper around the cloudflare-turnstile-rails
  gem, for simple inclusion of Cloudflare Turnstile in your app.'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/RaspberryPiFoundation/rpi-turnstile'
  spec.metadata['changelog_uri'] = 'https://github.com/RaspberryPiFoundation/rpi-turnstile/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['{app,config,lib}/**/*', 'LICENSE', 'README.md']

  spec.required_ruby_version = '>= 3.2'

  spec.add_dependency 'cloudflare-turnstile-rails', '~> 1.2'
  spec.add_dependency 'rails', '>= 7.0', '< 9.0'
  spec.add_dependency 'sprockets-rails', '~> 3.4'
  spec.add_dependency 'view_component', '>= 2.0', '< 5.0'
end
