require 'rails_helper'

RSpec.describe Api::V1::ElectricityChargesSimulatorsController, type: :controller do
  before do
    company = FactoryBot.create(:company)
    plan = FactoryBot.create(:plan, company_id: company.id)
    FactoryBot.create(:basic_charge, plan_id: plan.id, ampere: 30, price: 858.00)
    FactoryBot.create(:basic_charge, plan_id: plan.id, ampere: 40, price: 1144.00)
    FactoryBot.create(:basic_charge, plan_id: plan.id, ampere: 50, price: 1430.00)
    FactoryBot.create(:basic_charge, plan_id: plan.id, ampere: 60, price: 1716.00)
    FactoryBot.create(:electricity_fee, plan_id: plan.id, classification_min: 0, classification_max: 120, price: 19.88)
    FactoryBot.create(:electricity_fee, plan_id: plan.id, classification_min: 121, classification_max: 300, price: 26.48)
    FactoryBot.create(:electricity_fee, plan_id: plan.id, classification_min: 301, classification_max: nil, price: 30.57)

    second_company = FactoryBot.create(:company, name: "株式会社サンダー")
    second_plan = FactoryBot.create(:plan, name: "テストサンダープラン", company_id: second_company.id)
    FactoryBot.create(:basic_charge, plan_id: second_plan.id, ampere: 15, price: 429.00)
    FactoryBot.create(:basic_charge, plan_id: second_plan.id, ampere: 30, price: 858.00)
    FactoryBot.create(:basic_charge, plan_id: second_plan.id, ampere: 40, price: 1144.00)
    FactoryBot.create(:basic_charge, plan_id: second_plan.id, ampere: 50, price: 1430.00)
    FactoryBot.create(:basic_charge, plan_id: second_plan.id, ampere: 60, price: 1716.80)
    FactoryBot.create(:electricity_fee, plan_id: second_plan.id, classification_min: 0, classification_max: 140, price: 23.67)
    FactoryBot.create(:electricity_fee, plan_id: second_plan.id, classification_min: 141, classification_max: 350, price: 23.88)
    FactoryBot.create(:electricity_fee, plan_id: second_plan.id, classification_min: 351, classification_max: nil, price: 26.41)
  end

  describe "GET /index" do

    it "responds successfully" do
      get :index, params: {ampere: 30, amount_used: 120}
      expect(response).to have_http_status "200"
    end

    it "successfully return two plans" do
      get :index, params: {ampere: 30, amount_used: 120}
      plans = JSON.parse(response.body)
      # 二件返却されていることを確認
      expect(plans.length).to eq(2)

      # 会社名、プラン名、価格が間違いないかそれぞれ確認
      expect(plans[0]["company_name"]).to eq("テスト会社")
      expect(plans[0]["plan_name"]).to eq("テストプラン")
      # 基本料金(858.00) + 従量料金(19.88 * 120) = 3243.6
      expect(plans[0]["price"]).to eq("3243.6")

      expect(plans[1]["company_name"]).to eq("株式会社サンダー")
      expect(plans[1]["plan_name"]).to eq("テストサンダープラン")
      # 基本料金(858.00) + 従量料金(23.67 * 120) = 3698.4
      expect(plans[1]["price"]).to eq("3698.4")
    end

    it "successfully return one plan" do
      # 15Aの基本料金プランは２データのうち片方にしか存在しないため一件しか帰ってこないことを検証
      get :index, params: {ampere: 15, amount_used: 120}
      plans = JSON.parse(response.body)
      # 一件のみ返却されていることを確認
      expect(plans.length).to eq(1)
    end

  end
end
