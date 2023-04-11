class Api::V1::Plan < ApplicationRecord
  belongs_to :api_v1_company, :class_name => 'Api::V1::Company'
  has_many :api_v1_basic_charges, dependent: :destroy, :class_name => 'Api::V1::BasicCharge', foreign_key: 'api_v1_plan_id'
  has_many :api_v1_usage_charges, dependent: :destroy, :class_name => 'Api::V1::UsageCharge', foreign_key: 'api_v1_plan_id'

  def basic_charge ampere
    basic_charge = self.api_v1_basic_charges.find_by(ampere: ampere).charge
    return basic_charge
  end

  def usage_charge kwh
    usage_record = self.api_v1_usage_charges.where('from_khw < ? AND to_khw > ?', kwh, kwh)
    usage_charge = (usage_record.first.charge * kwh) + usage_record.first.stacked_charge
    return usage_charge
  end
end
