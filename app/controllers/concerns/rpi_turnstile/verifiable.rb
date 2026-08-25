# frozen_string_literal: true

module RpiTurnstile
  module Verifiable
    extend ActiveSupport::Concern

    # Returns the full Cloudflare::Turnstile::Rails::VerificationResponse.
    #
    # The client's IP is sent to Cloudflare, which checks it against the one
    # the token was issued to. Pass remoteip: explicitly to override it, or
    # remoteip: nil to leave it out of the request altogether. Any other
    # keyword arguments are passed through too, i.e. idempotency_key.
    def rpi_turnstile_verified(**)
      response = params[Cloudflare::Turnstile::Rails::Cloudflare::RESPONSE_FIELD_NAME]

      RpiTurnstile::Api.verify(response:, remoteip: request.remote_ip, **)
    end

    def rpi_turnstile_verified?(**)
      rpi_turnstile_verified(**).success?
    end
  end
end
