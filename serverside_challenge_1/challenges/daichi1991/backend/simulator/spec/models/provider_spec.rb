require 'rails_helper'

RSpec.describe Provider, type: :model do
  describe 'バリデーション' do
    it '正常に作成されればOK' do
      provider = build(:provider, :providerA)
      expect(provider.valid?).to eq(true)
    end

    it 'provider_codeが空だとNG' do
      provider = build(:provider, :providerA)
      provider.provider_code = ''
      expect(provider.valid?).to eq(false)
    end

    it 'provider_nameが空だとNG' do
      provider = build(:provider, :providerA)
      provider.provider_name = ''
      expect(provider.valid?).to eq(false)
    end

    it 'factoryのファイルが全て生成されていればOK' do
      create(:provider, :providerA)
      create(:provider, :providerB)
      create(:provider, :providerC)
      providers = Provider.all
      expect(providers.size).to eq(3)
    end
  end
end
