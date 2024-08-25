# == Schema Information
#
# Table name: plans
#
#  id              :bigint           not null, primary key
#  name(プラン名)  :string           not null
#  price(電気料金) :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  providers_id    :bigint           not null
#
# Indexes
#
#  index_plans_on_providers_id  (providers_id)
#
# Foreign Keys
#
#  fk_rails_...  (providers_id => providers.id)
#
class Plan < ApplicationRecord
  belongs_to :provider
end
