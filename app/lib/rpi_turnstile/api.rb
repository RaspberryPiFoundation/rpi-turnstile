# frozen_string_literal: true

module RpiTurnstile
  class Api
    SITEKEY = ENV.fetch('CLOUDFLARE_TURNSTILE_SITEKEY', nil)
    SECRET  = ENV.fetch('CLOUDFLARE_TURNSTILE_SECRET', nil)

    class << self
      def verify(...)
        new.verify(...)
      end
    end

    # Any extra keyword arguments are passed through to the underlying
    # verification call, i.e. remoteip and idempotency_key.
    def verify(response:, secret: SECRET, **)
      # The underlying gem raises when no secret is configured. We'd rather let
      # environments without keys through than break them.
      if secret.blank?
        Rails.logger.warn('Unable to verify turnstile response as no secret has been given')
        return Cloudflare::Turnstile::Rails::VerificationResponse.new('success' => true)
      end

      Cloudflare::Turnstile::Rails::Verification.verify(response:, secret:, **)
    end
  end
end
