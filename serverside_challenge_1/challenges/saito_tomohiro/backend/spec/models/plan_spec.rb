require 'rails_helper'

RSpec.describe Plan, type: :model do
  it 'is invalid with duplicated name' do
    create(:plan, id: 5)
    duplicated_plan = build(:plan)
    expect(duplicated_plan).to be_invalid
  end
end
