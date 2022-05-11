require 'rails_helper'

RSpec.describe UsageFee, type: :model do
  let!(:provider) { create(:provider, name: 'provider_hoge') }
  let!(:plan) { create(:plan, provider: provider, name: 'plan_hoge') }

  describe 'valid_min_max' do
    context 'when max_usage is smaller than min_usage' do
      it 'is invalid' do
        usage_fee = build(:usage_fee, plan: plan, min_usage: 10, max_usage: 1)
        expect(usage_fee).to be_invalid
      end
    end
  end
end
