require 'rails_helper'

RSpec.describe Provider, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:plans).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
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
