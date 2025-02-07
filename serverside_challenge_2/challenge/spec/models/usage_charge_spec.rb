# frozen_string_literal: true

# == Schema Information
#
# Table name: usage_charges
#
#  id          :bigint           not null, primary key
#  charge      :decimal(10, 2)   not null
#  lower_limit :integer          not null
#  state       :integer          default("active"), not null
#  upper_limit :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  plan_id     :bigint           not null
#
# Indexes
#
#  index_usage_charges_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id) ON DELETE => cascade
#
require "rails_helper"

RSpec.describe UsageCharge, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:plan).class_name("Plan") }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:state).with_values(inactive: 0, active: 1).with_prefix(true) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:lower_limit) }
    it { is_expected.to validate_numericality_of(:lower_limit).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:charge) }
    it { is_expected.to validate_numericality_of(:charge).is_greater_than_or_equal_to(0) }

    context "upper_limit" do
      it "be_valid" do
        usage = build(:usage_charge)
        expect(usage).to be_valid
      end

      it "be_valid" do
        usage = build(:usage_charge, :with_upper_limit_null)
        expect(usage).to be_valid
      end

      it "be_invalid" do
        usage = build(:usage_charge, lower_limit: 0, upper_limit: 0)
        expect(usage).to be_invalid
      end

      it "be_invalid" do
        usage = build(:usage_charge, lower_limit: 1, upper_limit: 0)
        expect(usage).to be_invalid
      end
    end
  end
end
