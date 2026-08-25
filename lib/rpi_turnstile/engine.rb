# frozen_string_literal: true

require 'cloudflare/turnstile/rails'
require 'view_component'

module RpiTurnstile
  class Engine < ::Rails::Engine
    isolate_namespace RpiTurnstile
  end
end
