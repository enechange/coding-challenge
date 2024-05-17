# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BasicRate, type: :model do
  let(:amperage) { 10 }

  let(:provider) { create(:provider) }
  let!(:electricity_plan) { create(:electricity_plan, provider:) }
  let!(:basic_rate) { create(:basic_rate, electricity_plan:, amperage: 10, rate: 10.10) }

  describe 'validations' do
    describe 'presence' do
      it { should validate_presence_of(:amperage) }
      it { should validate_presence_of(:rate) }
    end

    describe 'uniqueness' do
      it { should validate_uniqueness_of(:amperage).scoped_to(:electricity_plan_id) }
    end

    describe 'numericality' do
      it { should validate_numericality_of(:rate).is_greater_than_or_equal_to(0) }
    end
  end

  describe 'find_rate_by_amperage' do
    subject { BasicRate.find_rate_by_amperage(amperage) }

    it '契約アンペア数に対応する基本料金が返ること' do
      is_expected.to eq(10.10)
    end
  end
end
