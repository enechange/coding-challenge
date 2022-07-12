# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricPowerProvider, type: :model do
  it '名があり、名が重複しない場合、有効である' do
    provider = build(:provider)
    expect(provider).to be_valid
  end

  it '名がない場合、無効である' do
    provider = build(:provider, name: nil)
    provider.valid?
    expect(provider.errors[:name]).to include('を入力してください')
  end

  it '名が重複する場合、無効である' do
    create(:provider)
    provider = build(:provider)
    provider.valid?
    expect(provider.errors[:name]).to include('はすでに存在します')
  end
end
