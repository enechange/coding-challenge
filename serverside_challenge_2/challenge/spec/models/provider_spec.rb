# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Provider do
  describe 'バリデーション' do
    it 'name が空だと invalid になる' do
      record = build(:provider, name: nil)
      expect(record).not_to be_valid
      expect(record.errors[:name]).to be_present
    end
  end

  describe 'アソシエーション' do
    it 'has_many :plans が引ける' do
      provider = create(:provider)
      create_list(:plan, 2, provider: provider)
      expect(provider.plans.size).to eq 2
    end
  end
end
