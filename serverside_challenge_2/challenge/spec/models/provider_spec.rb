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
require "rails_helper"

RSpec.describe Provider, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:plans).class_name("Plan") }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:state).with_values(inactive: 0, active: 1).with_prefix(true) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:provider_type) }
    it { is_expected.to validate_uniqueness_of(:provider_type) }
  end
end
