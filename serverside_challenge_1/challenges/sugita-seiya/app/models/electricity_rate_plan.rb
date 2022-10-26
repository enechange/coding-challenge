class ElectricityRatePlan < ApplicationRecord
  belongs_to :electric_power_provider
  has_many :basic_charges, dependent: :destroy
  has_many :usage_charges, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: { scope: :electric_power_provider_id, message: '電力会社名、プラン名の組み合わせは存在します。' }

  validates :electric_power_provider_id, presence: true
end
