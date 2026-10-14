# frozen_string_literal: true

module RpiTurnstile
  class Api
    API_URL = ::Cloudflare::Turnstile::Rails::Cloudflare::SITE_VERIFY_URL
    SITEKEY = ENV.fetch('CLOUDFLARE_TURNSTILE_SITEKEY', nil)
    SECRET  = ENV.fetch('CLOUDFLARE_TURNSTILE_SECRET', nil)

    class << self
      def siteverify(...)
        new.siteverify(...)
      end
    end

    def siteverify(response:, secret: SECRET) # rubocop:disable Naming/PredicateMethod
      if secret.blank?
        Rails.logger.warn('Unable to verify turnstile response as no secret has been given')
        return true
      end

      ::Cloudflare::Turnstile::Rails::Verification.verify(response: response, secret: secret).success?
    end
  end
end
