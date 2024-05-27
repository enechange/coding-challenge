# frozen_string_literal: true

class Provider < ApplicationRecord
  has_many :electricity_plans, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
end
