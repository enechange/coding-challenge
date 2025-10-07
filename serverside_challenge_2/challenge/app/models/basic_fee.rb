class BasicFee < ApplicationRecord
  belongs_to :plan, primary_key: :code, foreign_key: :plan_code

  validates :ampere, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :ampere, uniqueness: { scope: :plan_code }
  validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # @param ampere [Integer] 契約アンペア数(A)
  scope :by_ampere, ->(ampere) { where(ampere:) }
end

# == Schema Information
#
# Table name: basic_fees
#
#  id                        :bigint           not null, primary key
#  ampere(契約アンペア数(A)) :integer          not null
#  code                      :string           not null
#  fee(基本料金(円))         :decimal(10, 2)   not null
#  plan_code                 :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_basic_fees_on_ampere                (ampere)
#  index_basic_fees_on_code                  (code) UNIQUE
#  index_basic_fees_on_plan_code_and_ampere  (plan_code,ampere) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_code => plans.code)
#
