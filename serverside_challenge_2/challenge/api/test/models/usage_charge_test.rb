# frozen_string_literal: true

# == Schema Information
#
# Table name: usage_charges
#
#  id         :bigint           not null, primary key
#  from_kwh   :integer          not null
#  to_kwh     :integer
#  unit_price :decimal(8, 2)    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_usage_charges_on_plan_id               (plan_id)
#  index_usage_charges_on_plan_id_and_from_kwh  (plan_id,from_kwh) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
require 'test_helper'

class UsageChargeTest < ActiveSupport::TestCase
  setup do
    @plan = create(:plan)
  end

  subject { build(:usage_charge) }
  should belong_to(:plan)

  should validate_presence_of(:from_kwh)
  should validate_uniqueness_of(:from_kwh).scoped_to(:plan_id)
  should validate_numericality_of(:from_kwh)
    .only_integer
    .is_greater_than_or_equal_to(0)
    .is_less_than_or_equal_to(ApplicationRecord::INTEGER_MAX)
  should validate_numericality_of(:to_kwh)
    .only_integer
    .allow_nil
  should validate_presence_of(:unit_price)
  should validate_numericality_of(:unit_price)
    .is_greater_than_or_equal_to(0)
    .is_less_than_or_equal_to(UsageCharge::MAX_AMOUNT)

  test 'from_kwhがto_kwhより小さい場合は有効' do
    usage_charge = build(:usage_charge, plan: @plan, from_kwh: 101, to_kwh: 200)

    assert { usage_charge.valid? }
  end

  test 'from_kwhがto_kwhより大きい場合は無効' do
    usage_charge = build(:usage_charge, plan: @plan, from_kwh: 20, to_kwh: 10)

    assert { usage_charge.invalid? }
    assert { usage_charge.errors.full_messages.include?('使用量(kwh)の上限は使用量(kwh)の下限より大きくなければなりません') }
  end

  test '使用量範囲が他の使用量範囲と重複していない場合は有効' do
    create(:usage_charge, plan: @plan, from_kwh: 10, to_kwh: 20)
    usage_charge = build(:usage_charge, plan: @plan, from_kwh: 21, to_kwh: 30)

    assert { usage_charge.valid? }
  end

  test '使用量範囲が他の使用量範囲と重複している場合は無効' do
    create(:usage_charge, plan: @plan, from_kwh: 10, to_kwh: 20)
    usage_charge = build(:usage_charge, plan: @plan, from_kwh: 20, to_kwh: 30)

    assert { usage_charge.invalid? }
    assert { usage_charge.errors.full_messages.include?('使用量範囲が他の区分と重複しています') }
  end

  test 'to_kwhがnilの場合でも重複チェックが正しく動作する' do
    create(:usage_charge, plan: @plan, from_kwh: 0, to_kwh: nil)
    usage_charge = build(:usage_charge, plan: @plan, from_kwh: 1, to_kwh: nil)

    assert { usage_charge.invalid? }
    assert { usage_charge.errors.full_messages.include?('使用量範囲が他の区分と重複しています') }
  end

  test '別のプランの使用量範囲と重複している場合は有効' do
    provider = create(:provider)
    plan1 = create(:plan, provider: provider)
    plan2 = create(:plan, provider: provider)
    create(:usage_charge, plan: plan1, from_kwh: 0, to_kwh: nil)
    usage_charge = build(:usage_charge, plan: plan2, from_kwh: 1, to_kwh: nil)

    assert { usage_charge.valid? }
  end
end
