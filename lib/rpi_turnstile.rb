# frozen_string_literal: true

require 'cloudflare/turnstile/rails'
require 'rpi_turnstile/version'
require 'rpi_turnstile/engine'

# RpiTurnstile is deprecated in favour of the cloudflare-turnstile-rails gem,
# which it now wraps.  See the README for migration instructions.
module RpiTurnstile
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('1.0', 'rpi_turnstile')
  end
end
