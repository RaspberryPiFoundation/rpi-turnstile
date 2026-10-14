# frozen_string_literal: true

module RpiTurnstile
  module Verifiable
    extend ActiveSupport::Concern

    def rpi_turnstile_verified?
      RpiTurnstile.deprecator.warn(
        'rpi_turnstile_verified? is deprecated; use valid_turnstile? from cloudflare-turnstile-rails instead.'
      )

      return true if RpiTurnstile::Api::SITEKEY.blank?

      RpiTurnstile::Api.siteverify(response: params['cf-turnstile-response'])
    end
  end
end
