# frozen_string_literal: true

# == Schema Information
#
# Table name: electricity_usages
#
#  id                               :bigint           not null, primary key
#  from(電気使用量(開始値))         :integer          default(0), not null
#  to(電気使用量時(終了値))         :integer          default(0)
#  unit_price(従量料金単価(円/kWh)) :money            default(0.0), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  plan_id                          :bigint           not null
#
# Indexes
#
#  index_electricity_usages_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
class ElectricityUsage < ApplicationRecord
  belongs_to :plan

  validates :to, uniqueness: { scope: :plan, message: '同一プランにて同じ値を設定することはできません' }, allow_nil: true
  validates :from, uniqueness: { scope: :plan, message: '同一プランにて同じ値を設定することはできません' }

  include ActiveModel::Validations
  validates_with Validator::PeriodValidator
end
