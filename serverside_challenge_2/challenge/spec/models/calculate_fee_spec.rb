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
          is_expected.to eq [{ planName: plan.name,
                               price: basic_monthly_fee.price + electricity_usage.unit_price * usage,
                               providerName: plan.provider.name }]
        end
      end

      context '契約アンペアの種類が複数存在する場合' do
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 100) }

        before { create(:basic_monthly_fee, contract_amperage: 20, plan:) }

        it do
          is_expected.to eq [{ planName: plan.name,
                               price: basic_monthly_fee.price + electricity_usage.unit_price * usage,
                               providerName: plan.provider.name }]
        end
      end

      context '従量金額が0円のプランのみが登録されている場合' do
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 100, unit_price: 0.00) }

        it do
          is_expected.to eq [{ planName: plan.name,
                               price: basic_monthly_fee.price,
                               providerName: plan.provider.name }]
        end
      end

      context '従量金額で少数点第一位が5以上の金額が出るプランのみが登録されている場合' do
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 100, unit_price: 140.05) }

        it do
          is_expected.to eq [{ planName: plan.name,
                               price: (basic_monthly_fee.price + electricity_usage.unit_price * usage).floor,
                               providerName: plan.provider.name }]
        end
      end

      context '段階金額が設定されている場合' do
        let(:plan) { create(:plan, usage_tier: true) }
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:first_electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 120) }
        let!(:second_electricity_usage) { create(:electricity_usage, plan:, from: 121, to: 300) }
        let!(:thrid_electricity_usage) { create(:electricity_usage, plan:, from: 301, to: nil) }

        context '電気使用量が120以下の場合' do
          let(:usage) { 120 }

          it do
            is_expected.to eq [{ planName: plan.name,
                                 price: basic_monthly_fee.price + first_electricity_usage.unit_price * usage,
                                 providerName: plan.provider.name }]
          end
        end

        context '電気使用量が120よりも大きい場合' do
          let(:usage) { 121 }

          it do
            is_expected.to eq [{ planName: plan.name,
                                 price: basic_monthly_fee.price + first_electricity_usage.unit_price * 120 +
                                        second_electricity_usage.unit_price,
                                 providerName: plan.provider.name }]
          end
        end

        context '電気使用量が300の場合' do
          let(:usage) { 300 }

          it do
            is_expected.to eq [{ planName: plan.name,
                                 price: basic_monthly_fee.price + first_electricity_usage.unit_price * 120 +
                                        second_electricity_usage.unit_price * 180,
                                 providerName: plan.provider.name }]
          end
        end

        context '電気使用量が301の場合' do
          let(:usage) { 301 }

          it do
            is_expected.to eq [{ planName: plan.name,
                                 price: basic_monthly_fee.price + first_electricity_usage.unit_price * 120 +
                                        second_electricity_usage.unit_price * 180 + thrid_electricity_usage.unit_price,
                                 providerName: plan.provider.name }]
          end
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
          is_expected.to eq [{ planName: plan.name,
                               price: basic_monthly_fee.price + electricity_usage.unit_price * usage,
                               providerName: plan.provider.name }]
        end
      end

      context '複数件一致する場合' do
        let!(:basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan:) }
        let!(:electricity_usage) { create(:electricity_usage, plan:, from: 1, to: 100) }
        let!(:other_basic_monthly_fee) { create(:basic_monthly_fee, contract_amperage: 10, plan: other_plan) }
        let!(:other_electricity_usage) { create(:electricity_usage, plan: other_plan, from: 1, to: 100) }

        it do
          is_expected.to eq [{ planName: plan.name,
                               price: basic_monthly_fee.price + electricity_usage.unit_price * usage,
                               providerName: plan.provider.name },
                             { planName: other_plan.name,
                               price: other_basic_monthly_fee.price + other_electricity_usage.unit_price * usage,
                               providerName: other_plan.provider.name }]
        end
      end
    end
  end
end
