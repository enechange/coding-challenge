# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityRatePlan, type: :model do
  let(:provider) { create(:provider) }

  it '名があり、electric_power_provider_idとプラン名が重複しない場合、有効である' do
    plan = build(:plan, electric_power_provider: provider)
    expect(plan).to be_valid
  end

  it '名がない場合、無効である' do
    plan = build(:plan, name: nil, electric_power_provider: provider)
    plan.valid?
    expect(plan.errors[:name]).to include('を入力してください')
  end

  it 'electric_power_provider_idが無い場合、無効である' do
    plan = build(:plan)
    plan.valid?
    expect(plan.errors[:electric_power_provider_id]).to include('を入力してください')
  end

  it 'electric_power_provider_idとプラン名が一意でない場合、無効である' do
    create(:plan, electric_power_provider: provider)
    plan = build(:plan, electric_power_provider: provider)
    plan.valid?
    expect(plan.errors[:name]).to include('電力会社名、プラン名の組み合わせは存在します')
  end
end
