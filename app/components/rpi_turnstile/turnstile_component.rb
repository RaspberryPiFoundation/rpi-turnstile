# frozen_string_literal: true

require 'rpi_turnstile/api'

module RpiTurnstile
  class TurnstileComponent < ViewComponent::Base
    BASE_CLASS = 'rpi-turnstile'

    def initialize(attrs: {}, **kwargs)
      super

      classes = [BASE_CLASS]
      classes += Array(attrs[:class])

      data = { controller: 'rpi-turnstile--turnstile',
               'rpi-turnstile--turnstile-target': 'container',
               'rpi-turnstile--turnstile-language-value': I18n.locale || :en,
               'rpi-turnstile--turnstile-sitekey-value': sitekey }

      data.merge!(kwargs.transform_keys { |k| "rpi-turnstile--turnstile-#{k}-value" })

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
