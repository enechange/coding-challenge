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
require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  subject { build(:provider) }

  should have_many(:plans)
  should validate_presence_of(:name)
  should validate_presence_of(:code)
  should validate_uniqueness_of(:code)
end
