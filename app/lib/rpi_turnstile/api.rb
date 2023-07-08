# frozen_string_literal: true

require 'faraday'

module RpiTurnstile
  class Api
    API_URL = 'https://challenges.cloudflare.com/turnstile/v0/siteverify'
    SITEKEY = ENV.fetch('CLOUDFLARE_TURNSTILE_SITEKEY', nil)
    SECRET  = ENV.fetch('CLOUDFLARE_TURNSTILE_SECRET', nil)

    class << self
      def siteverify(...)
        new.siteverify(...)
      end
    end

    def siteverify(response:, secret: SECRET)
      if secret.blank?
        Rails.logger.warn('Unable to verify turnstile response as no secret has been given')
        return true
      end

      response = conn.post(API_URL, response:, secret:)

      response.body['success']
    end

    private

    def conn
      @conn ||= Faraday.new(API_URL) do |f|
        f.request :instrumentation
        f.request :url_encoded
        f.response :raise_error
        f.response :json
      end
    end
  end
end
