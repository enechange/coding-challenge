require 'rails_helper'

RSpec.describe Provider, type: :model do
  it 'is invalid with duplicated name' do
    create(:provider)
    duplicated_provider = build(:provider)
    expect(duplicated_provider).to be_invalid
  end
end
