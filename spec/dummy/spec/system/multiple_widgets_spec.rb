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

    it 'renders a widget into both containers' do
      expect(page).to have_css('div.cf-turnstile > div', count: 2, visible: :all)
    end

    it 'gives both widgets a response token to submit' do
      expect(page).to have_css('div.cf-turnstile input[name="cf-turnstile-response"]', count: 2, visible: :all)
    end

    it 'only emits the loader script once' do
      # cloudflare-turnstile-rails guards this with an ivar on the view context,
      # which is why the component calls the helper via `helpers` rather than on
      # itself — each component instance would otherwise emit its own copy.
      expect(page).to have_css('script[src*="cloudflare_turnstile_helper"]', count: 1, visible: :all)
    end

    it 'only injects a single Turnstile script tag' do
      expect(page).to have_css('script[src*="challenges.cloudflare.com/turnstile"]', count: 1, visible: :all)
    end
  end
end
