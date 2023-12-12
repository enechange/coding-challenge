# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InitializeChargePlan do
  let(:provider) { '東京ガス株式会社' }
  let(:providers_data) do
    {
      '東京ガス株式会社' => {
        'basic_charges' => { 10 => nil, 15 => nil, 20 => nil, 30 => 858.00, 40 => 1144.00, 50 => 1430.00,
                             60 => 1716.00 },
        'tiers' => { 140 => 23.67, 210 => 23.88, 'Infinity' => 26.41 },
        'plan' => 'ずっとも電気1'
      }
    }
  end

  before do
    allow(YAML).to receive(:load_file).and_return({ 'providers' => providers_data })
  end

  subject(:initialize_data) { described_class.new(provider) }

  describe '#initialize' do
    it 'プロバイダー情報が正確にロードされる' do
      expect(initialize_data.provider).to eq(provider)
      expect(initialize_data.plan).to eq('ずっとも電気1')
      expect(initialize_data.basic_charges).to eq({ 10 => nil, 15 => nil, 20 => nil, 30 => 858.00, 40 => 1144.00,
                                                    50 => 1430.00, 60 => 1716.00 })
      expect(initialize_data.tiers).to eq(140 => 23.67, 210 => 23.88, Float::INFINITY => 26.41)
    end
  end
end
