# frozen_string_literal: true

require 'importmap-rails'
require 'view_component'

module RpiTurnstile
  class Engine < ::Rails::Engine
    isolate_namespace RpiTurnstile

    initializer 'rpi_turnstile.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << Engine.root.join('config/importmap.rb')
    end

    initializer 'rpi_turnstile.assets' do |app|
      app.config.assets.paths << Engine.root.join('app/javascript')
      app.config.assets.precompile += ['rpi_turnstile_manifest.js']
    end
  end
end
