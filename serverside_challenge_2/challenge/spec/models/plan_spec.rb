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
require "rails_helper"

RSpec.describe Plan, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:provider).class_name("Provider") }
    it { is_expected.to have_many(:basic_charges).class_name("BasicCharge") }
    it { is_expected.to have_many(:usage_charges).class_name("UsageCharge") }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:state).with_values(inactive: 0, active: 1).with_prefix(true) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:plan_type) }
    it { is_expected.to validate_uniqueness_of(:plan_type).scoped_to(:provider_id) }
  end

  describe "instance methods" do
    describe "#calculate_service_class" do

      let!(:test_plan) { create(:plan, :with_charges) }

      it do
        expect(test_plan.calculate_service_class).to eq(ElectricityChargeCalculator::BaseService)

        metered_lighting_b = Plan.find_by(plan_type: "metered_lighting_b")
        expect(metered_lighting_b.calculate_service_class).to eq(ElectricityChargeCalculator::Tepco::MeteredLightingBService)

        standard_s = Plan.find_by(plan_type: "standard_s")
        expect(standard_s.calculate_service_class).to eq(ElectricityChargeCalculator::Tepco::StandardSService)

        zuttomo1 = Plan.find_by(plan_type: "zuttomo1")
        expect(zuttomo1.calculate_service_class).to eq(ElectricityChargeCalculator::TokyoGass::Zuttomo1Service)

        ouchi = Plan.find_by(plan_type: "ouchi")
        expect(ouchi.calculate_service_class).to eq(ElectricityChargeCalculator::LoopDenki::OuchiService)
      end
    end
  end
end
