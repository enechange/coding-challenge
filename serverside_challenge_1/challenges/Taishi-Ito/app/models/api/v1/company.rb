class Api::V1::Company < ApplicationRecord
  has_many :api_v1_plans, dependent: :destroy, :class_name => 'Api::V1::Plan', foreign_key: 'api_v1_company_id'
end
