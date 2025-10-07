class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy, primary_key: :code, foreign_key: :provider_code

  validates :name, presence: true
end

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
