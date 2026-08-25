# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RpiTurnstile::Verifiable do
  subject(:verified) { controller.rpi_turnstile_verified?(**opts) }

  # The concern only needs `params` and `request` from its host, so a bare
  # stand-in keeps this a unit test of the concern itself. The dummy app's
  # system specs cover it in a real controller.
  let(:controller) do
    Class.new do
      include RpiTurnstile::Verifiable

      def params
        { 'cf-turnstile-response' => 'abc123' }
      end

      def request
        ActionDispatch::TestRequest.create('REMOTE_ADDR' => '10.0.0.1')
      end
    end.new
  end

  let(:opts) { {} }
  let(:success) { true }
  let(:response) { instance_double(Cloudflare::Turnstile::Rails::VerificationResponse, success?: success) }

  before do
    stub_const('RpiTurnstile::Api::SITEKEY', 'sitekey123')
    stub_const('RpiTurnstile::Api::SECRET', 'def456')
    allow(RpiTurnstile::Api).to receive(:verify).and_return(response)
  end

  it { is_expected.to be(true) }

  it 'verifies the token from the request' do
    verified
    expect(RpiTurnstile::Api).to have_received(:verify).with(hash_including(response: 'abc123'))
  end

  it 'sends the client IP to Cloudflare' do
    verified
    expect(RpiTurnstile::Api).to have_received(:verify).with(hash_including(remoteip: '10.0.0.1'))
  end

  it 'passes extra options through' do
    controller.rpi_turnstile_verified?(idempotency_key: 'key1')
    expect(RpiTurnstile::Api).to have_received(:verify).with(hash_including(idempotency_key: 'key1'))
  end

  it 'returns the full response from rpi_turnstile_verified' do
    expect(controller.rpi_turnstile_verified).to be(response)
  end

  context 'when verification fails' do
    let(:success) { false }

    it { is_expected.to be(false) }
  end

  context 'when a remoteip is given explicitly' do
    let(:opts) { { remoteip: '192.0.2.9' } }

    it 'overrides the client IP' do
      verified
      expect(RpiTurnstile::Api).to have_received(:verify).with(hash_including(remoteip: '192.0.2.9'))
    end
  end

  context 'when remoteip is nil' do
    let(:opts) { { remoteip: nil } }

    # The underlying gem omits remoteip from the request when it is falsey.
    it 'leaves it out of the request' do
      verified
      expect(RpiTurnstile::Api).to have_received(:verify).with(hash_including(remoteip: nil))
    end
  end
end
