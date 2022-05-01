require 'rails_helper'

RSpec.describe Provider, type: :model do
  it 'is invalid with a duplicate name' do
    create(:provider, name: 'provider_hoge')
    duplicated_provider = build(:provider, name: 'provider_hoge')
    expect(duplicated_provider).to be_invalid
  end

  it 'is valid with a distinct name' do
    create(:provider, name: 'provider_hoge')
    distinct_provider = build(:provider, name: 'provider_huga')
    expect(distinct_provider).to be_valid
  end
end
