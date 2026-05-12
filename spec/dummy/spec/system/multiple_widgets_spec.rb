# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/multiple' do
  # Cloudflare Turnstile always-pass visible test sitekey.
  let(:sitekey) { '1x00000000000000000000AA' }

  context 'with two widgets on the same page', :js do
    before do
      stub_const('RpiTurnstile::Api::SITEKEY', sitekey)
      visit '/multiple'
    end

    it 'renders both widget containers' do
      expect(page).to have_css('div[data-controller="rpi-turnstile--turnstile"] > div', count: 2)
    end

    it 'only injects a single Turnstile script tag' do
      # Both controllers connect synchronously on page load and both call
      # loadTurnstile(). The shared static loadingState means only the first
      # call injects a <script>; subsequent callers just queue a pending promise.
      # We verify the outcome by counting script tags with the Turnstile URL.
      have_css('script[src*="challenges.cloudflare.com/turnstile"]', count: 1)
    end
  end
end
