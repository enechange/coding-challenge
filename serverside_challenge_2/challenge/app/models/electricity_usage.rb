# == Schema Information
#
# Table name: electricity_usages
#
#  id                               :bigint           not null, primary key
#  from(電気使用量(開始値))         :integer          default(0), not null
#  to(電気使用量時(終了値))         :integer          default(0)
#  unit_price(従量料金単価(円/kWh)) :integer          default(0), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  provider_id                      :bigint           not null
#
# Indexes
#
#  index_electricity_usages_on_provider_id  (provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id)
#
class ElectricityUsage < ApplicationRecord
  belongs_to :provider
end
