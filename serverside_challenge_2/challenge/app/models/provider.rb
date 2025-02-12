# frozen_string_literal: true

# == Schema Information
#
# Table name: providers
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  provider_type :string           not null
#  state         :integer          default("active"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_providers_on_provider_type  (provider_type) UNIQUE
#
class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy

  enum :state, {
    inactive: 0,
    active:   1
  }, prefix: true

  validates :name, presence: true
  validates :provider_type, presence: true, uniqueness: true
end
