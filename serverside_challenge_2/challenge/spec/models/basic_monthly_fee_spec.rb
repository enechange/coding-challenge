# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_monthly_fees
#
#  id                                :bigint           not null, primary key
#  contract_amperage(契約アンペア数) :integer          default(0), not null
#  price(基本料金(円))               :money            default(0.0), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  plan_id                           :bigint           not null
#
# Indexes
#
#  index_basic_monthly_fees_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
require 'rails_helper'

RSpec.describe BasicMonthlyFee, type: :model do
  describe '#validate' do
    let(:plan) { create(:plan) }
    let(:contract_amperage) { 10 }
    before { create(:basic_monthly_fee, contract_amperage:, plan:) }

    context '別のplan と紐づく場合' do
      it '同一契約アンペア数でもvalidation エラーとならないこと' do
        basic_monthly_fee = build(:basic_monthly_fee, contract_amperage:)
        expect(basic_monthly_fee.valid?).to eq true
      end
    end

    context '同一のplan と紐づく場合' do
      it '同一契約アンペア数だと validation エラーとなること' do
        basic_monthly_fee = build(:basic_monthly_fee, contract_amperage:, plan:)
        expect(basic_monthly_fee.valid?).to eq false
      end

      it '違う契約アンペア数の場合は validation エラーとならないこと' do
        basic_monthly_fee = build(:basic_monthly_fee, contract_amperage: 20, plan:)
        expect(basic_monthly_fee.valid?).to eq true
      end
    end
  end
end
