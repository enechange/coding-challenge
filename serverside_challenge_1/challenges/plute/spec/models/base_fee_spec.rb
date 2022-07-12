require 'rails_helper'

RSpec.describe BaseFee, type: :model do
  let!(:provider) { create(:provider, name: 'provider_hoge') }
  let!(:plan) { create(:plan, provider: provider, name: 'plan_hoge') }

  describe 'attribute: ampere' do
    context 'ampere is acceptable' do
      it 'is valid' do
        base_fee = build(:base_fee, plan: plan, ampere: 10)
        expect(base_fee).to be_valid
      end
    end 

    context 'ampere is unacceptable' do
      it 'is invalid' do
        base_fee = build(:base_fee, plan: plan, ampere: 11)
        expect(base_fee).to be_invalid
      end
    end 

    context 'when empty' do
      it 'is invalid' do
        base_fee = build(:base_fee, plan: plan, ampere: nil)
        expect(base_fee).to be_invalid
      end
    end
  end
end
