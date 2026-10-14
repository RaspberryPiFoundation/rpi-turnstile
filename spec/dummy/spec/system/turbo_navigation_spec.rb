# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Turbo navigation', :js do
  subject { page }

  # Cloudflare Turnstile always-pass visible test sitekey.
  let(:sitekey) { '1x00000000000000000000AA' }
  let(:widget_response) { "input[name='cf-turnstile-response'][value*='DUMMY']" }

  before do
    stub_const('RpiTurnstile::Api::SITEKEY', sitekey)
    visit '/'
    # Wait for the first widget to render before navigating away.
    page.has_css?(widget_response, visible: :all, wait: 10)
    click_link 'Go to random page'
  end

  it { is_expected.to have_css(widget_response, count: 1, visible: :all, wait: 10) }

  context 'when going back' do
    before do
      page.has_css?(widget_response, visible: :all, wait: 10)
      page.go_back
    end

    it { is_expected.to have_css(widget_response, count: 1, visible: :all, wait: 10) }
  end
end
