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
require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  subject { build(:plan) }

  should belong_to(:provider)
  should have_many(:basic_charges)
  should have_many(:usage_charges)

  should validate_presence_of(:name)
  should validate_presence_of(:code)
  should validate_uniqueness_of(:code).scoped_to(:provider_id)
end
