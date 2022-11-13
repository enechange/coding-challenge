class Kilowatto < ApplicationRecord
  belongs_to :plan

  validates :min_kilowatto, presence: true
  validates :kwh_unit, presence: true
  validates :kilowatto_price, presence: true
  validates :plan_id, presence: true

  include CsvImports

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "min_kilowatto", "max_kilowatto", "kwh_unit", "kilowatto_price", "plan_id"]
  end
end
