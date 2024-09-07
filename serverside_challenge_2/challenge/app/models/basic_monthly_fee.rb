# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_monthly_fees
#
#  id                                :bigint           not null, primary key
#  contract_amperage(契約アンペア数) :integer          default(0), not null
#  price(基本料金(円))               :money            default(0.0), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  plan_id                           :bigint           not null
#
# Indexes
#
#  index_basic_monthly_fees_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
class BasicMonthlyFee < ApplicationRecord
  belongs_to :plan

  validates :contract_amperage, uniqueness: { scope: :plan, message: :unique_value }
end
