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

    # cf-turnstile is the class the Cloudflare loader script looks for. Without
    # it the container renders but no widget is ever put inside it.
    it { is_expected.to have_css('div.cf-turnstile.rpi-turnstile') }

    it { is_expected.to have_css("div.rpi-turnstile[data-sitekey='#{sitekey}']") }

    it { is_expected.to have_css("div.rpi-turnstile[data-language='en']") }

    it 'includes the Turnstile loader script' do
      expect(page).to have_css('script[src*="cloudflare_turnstile_helper"]', visible: :hidden)
    end

    context 'when a class is set' do
      let(:attrs) { { class: 'foo' } }

      it { is_expected.to have_css('div.cf-turnstile.rpi-turnstile.foo') }
    end

    context 'when an ID is set' do
      let(:attrs) { { id: 'foo' } }

      it { is_expected.to have_css('div.rpi-turnstile#foo') }
    end

    context 'when another option is set' do
      let(:component) { described_class.new(theme: 'dark', attrs: {}) }

      it { is_expected.to have_css("div.rpi-turnstile[data-theme='dark']") }
    end

    context 'when an option uses the dashed form from the Cloudflare docs' do
      let(:component) { described_class.new('response-field-name': 'token', attrs: {}) }

      it { is_expected.to have_css("div.rpi-turnstile[data-response-field-name='token']") }
    end

    context 'when the locale is changed' do
      around do |example|
        I18n.with_locale(:fr) { example.run }
      end

      it { is_expected.to have_css("div.rpi-turnstile[data-language='fr']") }
    end

    context 'when a language is given explicitly' do
      let(:component) { described_class.new(language: 'de', attrs: {}) }

      it 'takes precedence over the locale' do
        expect(page).to have_css("div.rpi-turnstile[data-language='de']")
      end
    end
  end
end
