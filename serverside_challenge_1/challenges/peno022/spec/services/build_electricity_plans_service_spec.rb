# frozen_string_literal: true

require 'rails_helper'
require 'yaml'

RSpec.describe BuildElectricityPlansService do
  describe '#call' do
    context '電力会社のプランデータがあり、1つの電力会社に0、1つ、複数のプランがそれぞれ登録されているとき' do
      it 'プランを持たない電力会社のデータは含めずに、電力会社のプランをElectricityPlanの配列で返す' do
        data = YAML.load_file(Rails.root.join('spec/fixtures/test_electricity_plans.yml'))
        plans = described_class.new.call(data)
        expect(plans).to all(be_an_instance_of(ElectricityPlan))
        expect(plans.size).to eq 3
        expect(plans.map(&:provider).map(&:name)).to eq %w[電力会社A 電力会社A 電力会社B]
      end
    end

    context 'プランを持たない電力会社のみがあるとき' do
      it '空の配列を返す' do
        data = YAML.load_file(Rails.root.join('spec/fixtures/test_electricity_provider_without_plan.yml'))
        plans = described_class.new.call(data)
        expect(plans).to eq []
      end
    end
  end
end
