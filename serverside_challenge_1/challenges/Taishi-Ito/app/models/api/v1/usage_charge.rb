class Api::V1::UsageCharge < ApplicationRecord
  belongs_to :api_v1_plan, :class_name => 'Api::V1::Plan'
end
