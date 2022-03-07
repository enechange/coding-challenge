require 'rails_helper'

RSpec.describe Plan, type: :model do
  before do
    @plans = build(:plan)
  end

  describe'バリデーション' do
    it 'planとcompanyどちらも値が設定されていればOK' do
      expect(@plans.valid?).to eq(true)
    end
  end

end
