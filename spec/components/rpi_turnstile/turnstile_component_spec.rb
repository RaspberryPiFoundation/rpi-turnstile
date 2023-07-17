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

    it { is_expected.to have_css("div.rpi-turnstile[data-controller='rpi-turnstile--turnstile'][data-rpi-turnstile--turnstile-target='container'][data-rpi-turnstile--turnstile-sitekey-value='#{sitekey}']") }

    context 'when a class is set' do
      let(:attrs) { { class: 'foo' } }

      it { is_expected.to have_css('div.rpi-turnstile.foo') }
    end

    context 'when an ID is set' do
      let(:attrs) { { id: 'foo' } }

      it { is_expected.to have_css('div.rpi-turnstile#foo') }
    end

    context 'when another option is set' do
      let(:component) { described_class.new(foo: :bar, attrs: {}) }

      it { is_expected.to have_css("div.rpi-turnstile[data-rpi-turnstile--turnstile-foo-value='bar']") }
    end
  end
end
