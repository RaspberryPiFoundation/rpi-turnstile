# frozen_string_literal: true

module RpiTurnstile
  class TurnstileComponent < ViewComponent::Base
    BASE_CLASS = 'rpi-turnstile'
    # cloudflare-turnstile-rails only renders widgets with this class.
    WIDGET_CLASS = ::Cloudflare::Turnstile::Rails::Cloudflare::WIDGET_CLASS

    def initialize(attrs: {}, **kwargs)
      RpiTurnstile.deprecator.warn(
        'RpiTurnstile::TurnstileComponent is deprecated; use cloudflare_turnstile_tag ' \
        'from cloudflare-turnstile-rails instead.'
      )

      classes = [BASE_CLASS, WIDGET_CLASS]
      classes += Array(attrs[:class])

      @data = { language: I18n.locale || :en }.merge(attrs.fetch(:data, {}), kwargs)
      @attrs = attrs.except(:class, :data).merge(class: classes)
    end

    def sitekey
      RpiTurnstile::Api::SITEKEY
    end

    def render?
      sitekey.present?
    end

    def call
      helpers.cloudflare_turnstile_tag(site_key: sitekey, data: @data, **@attrs)
    end
  end
end
