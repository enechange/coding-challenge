# frozen_string_literal: true

# == Schema Information
#
# Table name: providers
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_providers_on_code  (code) UNIQUE
#
class Provider < ApplicationRecord
  include CsvImportable

  has_many :plans, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  class << self
    private

    def csv_attributes
      %w[code name]
    end

    def csv_upsert_unique_keys
      %w[code]
    end
  end
end
