require 'rails_helper'

RSpec.describe BaseCharge, type: :model do
  it 'is invalid with empty ampere' do
    base_charge = build(:base_charge, ampere: nil)
    expect(base_charge).to be_invalid
  end
end
