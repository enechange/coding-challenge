# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_charges
#
#  id         :bigint           not null, primary key
#  ampere     :integer          not null
#  charge     :decimal(10, 2)   not null
#  state      :integer          default("active"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_basic_charges_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id) ON DELETE => cascade
#
require "rails_helper"

RSpec.describe BasicCharge, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:plan).class_name("Plan") }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:state).with_values(inactive: 0, active: 1).with_prefix(true) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:ampere) }
    it { is_expected.to validate_inclusion_of(:ampere).in_array([ 10, 15, 20, 30, 40, 50, 60 ]) }
    it { is_expected.to validate_presence_of(:charge) }
    it { is_expected.to validate_numericality_of(:charge).is_greater_than_or_equal_to(0) }
  end
end
