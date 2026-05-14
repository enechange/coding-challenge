# frozen_string_literal: true

class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy

  validates :name, presence: true
end
