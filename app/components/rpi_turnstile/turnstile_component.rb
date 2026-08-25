# frozen_string_literal: true

module RpiTurnstile
  class TurnstileComponent < ViewComponent::Base
    BASE_CLASS = 'rpi-turnstile'

    # The class cloudflare-turnstile-rails' JavaScript looks for when deciding
    # which containers to render a widget into. It is only applied for us when
    # no class at all is given, and we always give one, so we add it ourselves.
    WIDGET_CLASS = Cloudflare::Turnstile::Rails::Cloudflare::WIDGET_CLASS

    def initialize(attrs: {}, **kwargs)
      classes = [WIDGET_CLASS, BASE_CLASS]
      classes += Array(attrs[:class])

      # Turnstile is configured through data-* attributes on the container.
      # See https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/#configurations
      # kwargs are merged last so that an explicit language: wins over the default.
      @options = { language: I18n.locale || :en }.merge(kwargs)

      @attrs = attrs.merge(class: classes)
    end

    def sitekey
      RpiTurnstile::Api::SITEKEY
    end

    def render?
      sitekey.present?
    end

    def call
      # Called on the view context rather than on the component so that the
      # "only emit the loader script once" guard is shared between components.
      helpers.cloudflare_turnstile_tag(site_key: sitekey, data: @options, **@attrs)
    end
  end
end
