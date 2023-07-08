# frozen_string_literal: true

require 'rpi_turnstile/api'

module RpiTurnstile
  module Verifiable
    extend ActiveSupport::Concern

    def rpi_turnstile_verified?
      return true if RpiTurnstile::Api::SITEKEY.blank?

      RpiTurnstile::Api.siteverify(response: params['cf-turnstile-response'])
    end
  end
end
