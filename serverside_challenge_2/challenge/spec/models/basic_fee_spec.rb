require 'rails_helper'

RSpec.describe BasicFee, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ampere) }
    it { is_expected.to validate_numericality_of(:ampere).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:fee) }
    it { is_expected.to validate_numericality_of(:fee).is_greater_than_or_equal_to(0) }

    describe 'uniqueness of plan_code and ampere combination' do
      let(:plan) { create(:plan) }
      let!(:existing_basic_fee) { create(:basic_fee, plan:, ampere: 30, fee: 1000) }

      context 'when combination already exists' do
        it 'is invalid with duplicate plan_code and ampere' do
          new_basic_fee = build(:basic_fee, plan:, ampere: 30, fee: 1500)
          expect(new_basic_fee).not_to be_valid
          expect(new_basic_fee.errors[:ampere]).to include('has already been taken')
        end
      end

      context 'when combination is unique' do
        it 'is valid with different plan' do
          other_plan = create(:plan)
          new_basic_fee = build(:basic_fee, plan: other_plan, ampere: 30, fee: 1000)
          expect(new_basic_fee).to be_valid
        end

        it 'is valid with different ampere' do
          new_basic_fee = build(:basic_fee, plan:, ampere: 40, fee: 1000)
          expect(new_basic_fee).to be_valid
        end
      end
    end
  end

  describe 'scopes' do
    describe '.by_ampere' do
      subject { described_class.by_ampere(ampere) }

      let(:ampere) { 30 }

      let!(:basic_fee_30A) { create(:basic_fee, ampere: 30) }
      let!(:basic_fee_40A) { create(:basic_fee, ampere: 40) }
      let!(:basic_fee_50A) { create(:basic_fee, ampere: 50) }

      it 'returns basic fees with the specified ampere' do
        expect(subject).to contain_exactly(basic_fee_30A)
      end
    end
  end
end

# == Schema Information
#
# Table name: basic_fees
#
#  id                        :bigint           not null, primary key
#  ampere(契約アンペア数(A)) :integer          not null
#  code                      :string           not null
#  fee(基本料金(円))         :decimal(10, 2)   not null
#  plan_code                 :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_basic_fees_on_ampere                (ampere)
#  index_basic_fees_on_code                  (code) UNIQUE
#  index_basic_fees_on_plan_code_and_ampere  (plan_code,ampere) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_code => plans.code)
#
