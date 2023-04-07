class Api::V1::Plan < ApplicationRecord
  belongs_to :api_v1_company
  has_many :api_v1_basic_charges, dependent: :destroy
end
