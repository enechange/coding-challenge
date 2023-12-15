# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InitializeChargePlan do
  let(:provider) { '東京ガス株式会社' }
  let(:plan) { 'ずっとも電気1' }

  before do
    allow(YAML).to receive(:load_file).and_call_original
    InitializeChargePlan.instance_variable_set(:@providers_data_cache, nil)
  end

  subject(:initialize_data) { described_class.new(provider, plan) }

  describe '#initialize' do
    it 'YAML.load_fileが2度目以降はキャッシュを使う' do
      InitializeChargePlan.load_providers
      InitializeChargePlan.load_providers
      expect(YAML).to have_received(:load_file).once
    end

    it 'プロバイダー情報が正確にロードされる' do
      expect(initialize_data.provider).to eq(provider)
      expect(initialize_data.plan).to eq('ずっとも電気1')
      expect(initialize_data.basic_charges).to eq({ 10 => nil, 15 => nil, 20 => nil, 30 => 858.00, 40 => 1144.00,
                                                    50 => 1430.00, 60 => 1716.00 })
      expect(initialize_data.tiers).to eq(140 => 23.67, 210 => 23.88, Float::INFINITY => 26.41)
    end
  end
end
