# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateFee, type: :model do
  describe '#call' do
    subject { described_class.call(ampere, usage) }

    let(:ampere) { 10 }
    let(:usage) { 10 }

    context 'plan が一件も登録されていない場合' do
      it { is_expected.to eq [] }
    end

    context 'plan が一件だけ登録されている場合' do
      let(:plan) { create(:plan) }
      context '契約アンペアが一致するプランが存在しない場合' do
        before { create(:basic_monthly_fee, contract_amperage: 20, plan:) }
        it { is_expected.to eq [] }
      end

      context '契約アンペアが一致するプランが存在する場合' do
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 100) }

        it do
          is_expected.to eq [{ plan_name: plan.name,
                               price: basic_monthly_fee.price + electricity_usage.unit_price * usage,
                               provider_name: plan.provider.name }]
        end
      end

      context '契約アンペアの種類が複数存在する場合' do
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 100) }

        before { create(:basic_monthly_fee, contract_amperage: 20, plan:) }

        it do
          is_expected.to eq [{ plan_name: plan.name,
                               price: basic_monthly_fee.price + electricity_usage.unit_price * usage,
                               provider_name: plan.provider.name }]
        end
      end
    end

    context 'plan が複数件(2件)登録されている場合' do
      let(:plan) { create(:plan) }
      let(:other_plan) { create(:plan) }

      context '1件だけ一致する場合' do
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 100) }

        it do
          is_expected.to eq [{ plan_name: plan.name,
                               price: basic_monthly_fee.price + electricity_usage.unit_price * usage,
                               provider_name: plan.provider.name }]
        end
      end

      context '複数件一致する場合' do
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 100) }
        let!(:other_basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan: other_plan) }
        let!(:other_electricity_usage) { create(:electricity_usage, plan: other_plan, from: 1, to: 100) }

        it do
          is_expected.to eq [{ plan_name: plan.name,
                               price: basic_monthly_fee.price + electricity_usage.unit_price * usage,
                               provider_name: plan.provider.name },
                             { plan_name: other_plan.name,
                               price: other_basic_monthly_fee.price + other_electricity_usage.unit_price * usage,
                               provider_name: other_plan.provider.name }]
        end
      end
    end
  end
end
