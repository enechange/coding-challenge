# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  plan_type   :string           not null
#  state       :integer          default("active"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  provider_id :bigint           not null
#
# Indexes
#
#  index_plans_on_provider_id                (provider_id)
#  index_plans_on_provider_id_and_plan_type  (provider_id,plan_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id) ON DELETE => cascade
#
class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_charges, dependent: :destroy
  has_many :usage_charges, dependent: :destroy

  enum :state, {
    inactive: 0,
    active:   1
  }, prefix: true

  validates :name, presence: true
  validates :plan_type, presence: true, uniqueness: { scope: :provider_id }

  def calculate_service_class
    [
      "electricity_charge_calculator".classify,
      provider.provider_type.classify,
      "#{plan_type}_service".classify
    ].join("::").constantize
  rescue NameError => e
    logger.warn("#{e.name} service class is not defined. Using the base service class.")
    [
      "electricity_charge_calculator".classify,
      "base_service".classify
    ].join("::").constantize
  end
end
