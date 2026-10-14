# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RpiTurnstile::TurnstileComponent, type: :component do
  subject { page }

  let(:component) { described_class.new(attrs: attrs) }
  let(:attrs) { {} }
  let(:sitekey) { nil }

  before do
    stub_const('RpiTurnstile::Api::SITEKEY', sitekey)
    render_inline(component)
  end

  context 'when the sitekey is not set' do
    it { is_expected.not_to be_rendered }
  end

  context 'when sitekey is set' do
    let(:sitekey) { 'abc' }

    it { is_expected.to have_css("div.rpi-turnstile.cf-turnstile[data-sitekey='abc'][data-language='en']") }

    it 'includes the cloudflare-turnstile-rails helper script' do
      expect(page).to have_css('script[src*="cloudflare_turnstile_helper"]', visible: :all)
    end

    context 'when a class is set' do
      let(:attrs) { { class: 'foo' } }

      it { is_expected.to have_css('div.rpi-turnstile.cf-turnstile.foo') }
    end

    context 'when an ID is set' do
      let(:attrs) { { id: 'foo' } }

      it { is_expected.to have_css('div.rpi-turnstile#foo') }
    end

    context 'when data attributes are set' do
      let(:attrs) { { data: { action: 'login' } } }

      it { is_expected.to have_css("div.rpi-turnstile[data-action='login'][data-sitekey='abc']") }
    end

    context 'when another option is set' do
      let(:component) { described_class.new(size: 'compact', attrs: {}) }

      it { is_expected.to have_css("div.rpi-turnstile[data-size='compact'][data-language='en']") }
    end

    context 'when the language is set' do
      let(:component) { described_class.new(language: 'fr') }

      it { is_expected.to have_css("div.rpi-turnstile[data-language='fr']") }
    end
  end
end
