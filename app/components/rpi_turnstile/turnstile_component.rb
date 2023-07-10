# frozen_string_literal: true

require 'rpi_turnstile/api'

module RpiTurnstile
  class TurnstileComponent < ViewComponent::Base
    BASE_CLASS = 'rpi-turnstile'

    def initialize(attrs: {})
      super

      classes = [BASE_CLASS]
      classes += Array(attrs[:class])

      data = { controller: 'rpi-turnstile--turnstile',
               'rpi-turnstile--turnstile-target': 'container',
               'rpi-turnstile--turnstile-sitekey-value': sitekey }

      Rails.logger.debug ENV.inspect

      @attrs = attrs.merge(class: classes, data: data)
    end

    def sitekey
      RpiTurnstile::Api::SITEKEY
    end

    def render?
      sitekey.present?
    end

    def call
      tag.div(**@attrs)
    end
  end
end
