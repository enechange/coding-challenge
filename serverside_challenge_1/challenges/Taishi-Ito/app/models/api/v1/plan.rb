class Api::V1::Plan < ApplicationRecord
  belongs_to :api_v1_company, :class_name => 'Api::V1::Company'
  has_many :api_v1_basic_charges, dependent: :destroy, :class_name => 'Api::V1::BasicCharge', foreign_key: 'api_v1_plan_id'
  has_many :api_v1_usage_charges, dependent: :destroy, :class_name => 'Api::V1::UsageCharge', foreign_key: 'api_v1_plan_id'
end
