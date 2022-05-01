require 'rails_helper'

RSpec.describe Plan, type: :model do
  it 'is invalid with a duplicate name' do
    create(:plan, name: 'plan_hoge')
    duplicated_plan = build(:plan, name: 'plan_hoge')
    expect(duplicated_plan).to be_invalid
  end

  it 'is valid with a distinct name' do
    create(:plan, name: 'plan_hoge')
    duplicated_plan = build(:plan, name: 'plan_huga')
    expect(duplicated_plan).to be_valid
  end
end
