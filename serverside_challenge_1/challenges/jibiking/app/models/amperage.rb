class Amperage < ApplicationRecord
  belongs_to :plan

  validates :amperage, presence: true
  validates :contract_unit, presence: true
  validates :amperage_price, presence: true
  validates :plan_id, presence: true

  include CsvImports

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "amperage", "contract_unit", "amperage_price", "plan_id"]
  end
end
