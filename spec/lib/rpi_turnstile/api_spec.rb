# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RpiTurnstile::Api do
  describe '#siteverify' do
    subject(:siteverify) { described_class.siteverify(**args) }

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
        .with(body: args)
        .to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })
    end

    it { is_expected.to be_truthy }

    context 'when verification fails' do
      let(:error_codes) { %w[invalid-input-response] }

      it { is_expected.to be_falsey }
    end

    context 'when no secret has been set' do
      let(:args) { { response: 'abc123', secret: nil } }

      it { is_expected.to be_truthy }

      it 'writes a warning to the log' do
        allow(Rails.logger).to receive(:warn)
        siteverify
        expect(Rails.logger).to have_received(:warn).with(an_instance_of(String))
      end
    end
  end
end
