# frozen_string_literal: true

require 'view_component'

module RpiTurnstile
  class Engine < ::Rails::Engine
    isolate_namespace RpiTurnstile

    # Rails 7.1+ applies the app's deprecation config to registered deprecators.
    initializer 'rpi_turnstile.deprecator' do |app|
      app.deprecators[:rpi_turnstile] = RpiTurnstile.deprecator if app.respond_to?(:deprecators)
    end

    # Seed the cloudflare-turnstile-rails configuration from the environment
    # variables this gem has always used, so that apps can migrate to
    # `cloudflare_turnstile_tag` and `valid_turnstile?` before renaming them.
    # Anything already set in the app's own initializer takes precedence.
    config.after_initialize do
      turnstile = ::Cloudflare::Turnstile::Rails.configuration
      turnstile.site_key ||= ENV.fetch('CLOUDFLARE_TURNSTILE_SITEKEY', nil)
      turnstile.secret_key ||= ENV.fetch('CLOUDFLARE_TURNSTILE_SECRET', nil)
    end
  end
end
