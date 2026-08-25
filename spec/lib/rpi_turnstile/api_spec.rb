# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RpiTurnstile::Api do
  let(:args) { { response: 'abc123', secret: 'def456' } }
  let(:error_codes) { [] }
  # See
  # https://developers.cloudflare.com/turnstile/get-started/server-side-validation/#accepted-parameters
  let(:response) do
    {
      challenge_ts: Time.now.utc,
      success: error_codes.empty?,
      'error-codes': error_codes
    }
  end

  before do
    stub_request(:post, RpiTurnstile::Api::API_URL)
      .to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })
  end

  describe '#verify' do
    subject(:verify) { described_class.verify(**args) }

    it { is_expected.to be_success }

    it 'sends the response and secret to Cloudflare' do
      verify
      expect(a_request(:post, RpiTurnstile::Api::API_URL).with(body: args)).to have_been_made
    end

    context 'when verification fails' do
      let(:error_codes) { %w[invalid-input-response] }

      it { is_expected.not_to be_success }

      it 'exposes the error codes' do
        expect(verify.errors).to eq(error_codes)
      end
    end

    context 'when a remoteip is given' do
      let(:args) { { response: 'abc123', secret: 'def456', remoteip: '10.0.0.1' } }

      it 'passes it on to Cloudflare' do
        verify
        expect(a_request(:post, RpiTurnstile::Api::API_URL).with(body: args)).to have_been_made
      end
    end

    context 'when an idempotency key is given' do
      let(:args) { { response: 'abc123', secret: 'def456', idempotency_key: 'key1' } }

      it 'passes it on to Cloudflare' do
        verify
        expect(a_request(:post, RpiTurnstile::Api::API_URL).with(body: args)).to have_been_made
      end
    end

    context 'when no secret has been set' do
      let(:args) { { response: 'abc123', secret: nil } }

      # Cloudflare::Turnstile::Rails::Verification raises a ConfigurationError
      # in this case; we log and let the request through so that environments
      # without keys still work.
      it { is_expected.to be_success }

      it 'does not call Cloudflare' do
        verify
        expect(a_request(:post, RpiTurnstile::Api::API_URL)).not_to have_been_made
      end

      it 'writes a warning to the log' do
        allow(Rails.logger).to receive(:warn)
        verify
        expect(Rails.logger).to have_received(:warn).with(an_instance_of(String))
      end
    end
  end

  describe '#siteverify' do
    subject(:siteverify) { described_class.siteverify(**args) }

    before { allow(RpiTurnstile.deprecator).to receive(:warn) }

    it { is_expected.to be(true) }

    it 'warns that it is deprecated' do
      siteverify
      expect(RpiTurnstile.deprecator).to have_received(:warn).with(an_instance_of(String), an_instance_of(Array))
    end

    context 'when verification fails' do
      let(:error_codes) { %w[invalid-input-response] }

      it { is_expected.to be(false) }
    end
  end
end
