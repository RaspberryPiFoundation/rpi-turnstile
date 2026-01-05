# frozen_string_literal: true

require 'rails_helper'
# require 'rpi_turnstile/api'

RSpec.describe '/' do
  subject { page }

  let(:url) { '/' }
  let(:secret) { nil }
  let(:sitekey) { nil }

  # Cloudflare Turnstile test site keys
  # 1x00000000000000000000AA  Always passes  visible
  # 2x00000000000000000000AB  Always blocks  visible
  # 1x00000000000000000000BB  Always passes  invisible
  # 2x00000000000000000000BB  Always blocks  invisible
  # 3x00000000000000000000FF  Forces an interactive challenge  visible

  # Cloudflare Turnstile test site secrets
  # 1x0000000000000000000000000000000AA  Always passes
  # 2x0000000000000000000000000000000AA  Always fails
  # 3x0000000000000000000000000000000AA  Yields a “token already spent” error

  before do
    stub_const('RpiTurnstile::Api::SITEKEY', sitekey)
    stub_const('RpiTurnstile::Api::SECRET', secret)
    visit url
  end

  context 'when CF turnstile is enabled', :js, skip: 'Not currently working selecting the iframe' do
    let(:secret) { '1x0000000000000000000000000000000AA' }
    let(:sitekey) { '1x00000000000000000000AA' }

    it 'has the challenge' do
      within_frame do
        expect(page).to have_text('Success!')
      end
    end

    context 'when CF fails' do
      let(:sitekey) { '2x00000000000000000000AB' }

      it 'has the challenge' do
        within_frame do
          expect(page).to have_text('Failure!')
        end
      end
    end
  end

  context 'when submiting the form' do
    context 'when CF turnstile is enabled' do
      let(:sitekey) { 'abc' }

      before do
        allow(RpiTurnstile::Api).to receive(:siteverify).and_return(true)
        click_button('Submit')
      end

      it 'verifies with CF' do
        expect(RpiTurnstile::Api).to have_received(:siteverify)
      end

      context 'when CF turnstile raises an error' do # rubocop:disable RSpec/NestedGroups
        before do
          allow(RpiTurnstile::Api).to receive(:siteverify).and_return(false)
          click_button('Submit')
        end

        it 'throws an error message' do
          expect(page).to have_text('Turnstile verification failed')
        end
      end
    end
  end
end
