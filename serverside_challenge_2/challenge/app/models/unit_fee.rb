class UnitFee < ApplicationRecord
  belongs_to :energy_plan_db, class_name: "EnergyPlanDb", foreign_key: :energy_plan_id
end