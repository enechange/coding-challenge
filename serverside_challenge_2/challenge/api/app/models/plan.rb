# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id          :bigint           not null, primary key
#  code        :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  provider_id :bigint           not null
#
# Indexes
#
#  index_plans_on_provider_id           (provider_id)
#  index_plans_on_provider_id_and_code  (provider_id,code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id)
#
class Plan < ApplicationRecord
  include CsvImportable
  belongs_to :provider
  has_many :basic_charges, dependent: :destroy
  has_many :usage_charges, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { scope: :provider_id }

  class << self
    private

    def convert_attrs!(attrs)
      @provider_code_ids ||= Provider.pluck(:code, :id).to_h
      convert_code_to_id(
        attrs,
        code_key: 'provider_code',
        id_key: 'provider_id',
        target_mappings: @provider_code_ids,
      )
    end

    def csv_attributes
      %w[provider_code name code]
    end

    def csv_upsert_unique_keys
      %w[provider_id code]
    end
  end
end
