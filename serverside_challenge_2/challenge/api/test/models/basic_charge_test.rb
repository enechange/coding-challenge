# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_charges
#
#  id         :bigint           not null, primary key
#  amount     :decimal(8, 2)    not null
#  ampere     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_basic_charges_on_plan_id             (plan_id)
#  index_basic_charges_on_plan_id_and_ampere  (plan_id,ampere) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
require 'test_helper'

class BasicChargeTest < ActiveSupport::TestCase
  subject { build(:basic_charge) }

  should belong_to(:plan)
  should validate_presence_of(:ampere)
  should validate_uniqueness_of(:ampere).scoped_to(:plan_id)
  should validate_numericality_of(:ampere)
    .only_integer
    .is_greater_than(0)
    .is_less_than_or_equal_to(ApplicationRecord::INTEGER_MAX)
  should validate_presence_of(:amount)
  should validate_numericality_of(:amount)
    .is_greater_than_or_equal_to(0)
    .is_less_than_or_equal_to(BasicCharge::MAX_AMOUNT)
end
