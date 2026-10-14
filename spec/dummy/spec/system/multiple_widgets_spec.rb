# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/multiple' do
  # Cloudflare Turnstile always-pass visible test sitekey.
  let(:sitekey) { '1x00000000000000000000AA' }

  before do
    stub_const('RpiTurnstile::Api::SITEKEY', sitekey)
    visit '/multiple'
  end

  it 'renders both widget containers' do
    expect(page).to have_css('div.rpi-turnstile.cf-turnstile', count: 2)
  end

  it 'only includes the helper script once' do
    expect(page).to have_css('script[src*="cloudflare_turnstile_helper"]', count: 1, visible: false)
  end

  context 'with JS enabled', :js do
    it 'renders both widgets' do
      expect(page).to have_css("input[name='cf-turnstile-response'][value*='DUMMY']", count: 2, visible: :all, wait: 10)
    end

    it 'only injects a single Turnstile script tag' do
      expect(page).to have_css('script[src*="challenges.cloudflare.com/turnstile"]', count: 1, visible: false)
    end
  end
end
