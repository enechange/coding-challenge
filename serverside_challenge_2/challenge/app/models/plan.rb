# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                                                 :bigint           not null, primary key
#  name(プラン名)                                     :string           not null
#  usage_tier(段階料金が導入されているのかを保持する) :boolean          default(FALSE)
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  provider_id                                        :bigint           not null
#
# Indexes
#
#  index_plans_on_provider_id  (provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id)
#
class Plan < ApplicationRecord
  belongs_to :provider

  has_many :electricity_usages, -> { order(:from) }
  has_many :basic_monthly_fees
end
