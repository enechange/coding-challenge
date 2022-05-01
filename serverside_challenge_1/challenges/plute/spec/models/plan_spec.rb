require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'attribute: name' do
    let!(:provider) { create(:provider, name: 'provider_hoge')}
    let!(:plan) { create(:plan, provider: provider, name: 'plan_hoge') }

    context 'when present' do
      it 'is valid' do
        expect(plan).to be_valid
      end

      it 'is valid with a distinct name' do
        distinct_plan = build(:plan, provider: provider, name: 'plan_huga')
        expect(distinct_plan).to be_valid
      end

      it 'is invalid with a duplicate name' do
        duplicated_plan = build(:plan, provider: provider, name: 'plan_hoge')
        expect(duplicated_plan).to be_invalid
      end
    end
  end
end
