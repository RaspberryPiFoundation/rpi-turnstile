# frozen_string_literal: true

require 'rpi_turnstile/version'
require 'rpi_turnstile/engine'

module RpiTurnstile
  # Rails 7.1 deprecated calling warn on ActiveSupport::Deprecation directly,
  # so the gem owns its own deprecator.
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('0.9', 'RpiTurnstile')
  end
end
