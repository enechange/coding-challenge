require 'rails_helper'

RSpec.describe CommodityCharge, type: :model do
  describe 'バリデーション OK' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
    end
    it '全ての値が設定されていればOK' do
      commodity_charge = build(:commodity_charge, :commodityChargeA1)
      expect(commodity_charge.valid?).to eq(true)
    end
  end
  describe 'バリデーション NG' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
    end
    it 'plan_idが設定されていなければNG' do
      commodity_charge = build(:commodity_charge, :commodityChargeA1)
      commodity_charge.plan_code = ''
      expect(commodity_charge.valid?).to eq(false)
    end
    it 'min_amountが設定されていなければNG' do
      commodity_charge = build(:commodity_charge, :commodityChargeA1)
      commodity_charge.min_amount = ''
      expect(commodity_charge.valid?).to eq(false)
    end
  end
  describe '検索系' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:commodity_charge, :commodityChargeA1)
      create(:commodity_charge, :commodityChargeA2)
      create(:commodity_charge, :commodityChargeA3)
    end
    it '正常に検索されていればOK' do
      records = CommodityCharge.commodity_charges_select.commodity_charges_where('PL000001',1000)
      expect(records.size).to eq(3)  
    end
    it '該当がない場合' do
      records = CommodityCharge.commodity_charges_select.commodity_charges_where('PL000005',1000)
      expect(records.size).to eq(0)  
    end
  end
  
  describe 'get_commodity_record' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:commodity_charge, :commodityChargeA1)
      create(:commodity_charge, :commodityChargeA2)
      create(:commodity_charge, :commodityChargeA3)
    end
    it '正常系' do
      records = CommodityCharge.get_commodity_record('PL000001',1000)
      expect(records.size).to eq(3)
    end
    it '検索結果がない場合' do
      records = CommodityCharge.get_commodity_record('PL000005',1000)
      expect(records.size).to eq(0)
    end  
  end
  describe 'calculate_step_price' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:commodity_charge, :commodityChargeA1)
      create(:commodity_charge, :commodityChargeA2)
      create(:commodity_charge, :commodityChargeA3)
    end
    it '正常系' do
      records = CommodityCharge.get_commodity_record('PL000001',1000)
      step_price = CommodityCharge.calculate_step_price(records,1000)
      expect(step_price).to eq(28551)
    end
    it 'kwhが0の場合の正常系' do
      records = CommodityCharge.get_commodity_record('PL000001',0)
      step_price = CommodityCharge.calculate_step_price(records,0)
      expect(step_price).to eq(0)
    end
    it '該当レコードが存在しない場合' do
      records = CommodityCharge.get_commodity_record('PL000005',1000)
      step_price = CommodityCharge.calculate_step_price(records,1000)
      expect(step_price).to eq(0)
    end
  end
  describe 'calculate_commodity_charge' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:commodity_charge, :commodityChargeA1)
      create(:commodity_charge, :commodityChargeA2)
      create(:commodity_charge, :commodityChargeA3)
    end
    it '正常系' do
      commodity_charge = CommodityCharge.calculate_commodity_charge('PL000001', 1000)
      expect(commodity_charge).to eq(28551)
    end
    it 'kwhが0の場合の正常系' do
      commodity_charge = CommodityCharge.calculate_commodity_charge('PL000001', 0)
      expect(commodity_charge).to eq(0)
    end
    it '該当レコードが存在しない場合' do
      commodity_charge = CommodityCharge.calculate_commodity_charge('PL000005', 1000)
      expect(commodity_charge).to eq(0)
    end
  end
end
