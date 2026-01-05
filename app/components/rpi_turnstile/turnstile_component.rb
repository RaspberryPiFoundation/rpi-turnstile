# frozen_string_literal: true

# require 'rpi_turnstile/api'

module RpiTurnstile
  class TurnstileComponent < ViewComponent::Base
    BASE_CLASS = 'rpi-turnstile'

    def initialize(attrs: {}, **kwargs)
      super

      classes = [BASE_CLASS]
      classes += Array(attrs[:class])

      data = { controller: 'rpi-turnstile--turnstile',
               'rpi-turnstile--turnstile-target': 'container' }

      options = kwargs.merge(language: I18n.locale || :en, sitekey: sitekey)
      data['rpi-turnstile--turnstile-options-value'] = options.to_json

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
