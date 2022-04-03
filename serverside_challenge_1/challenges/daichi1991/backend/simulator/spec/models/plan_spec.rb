require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'バリデーション' do
    before do
      create(:provider, :providerA)
    end
    it '正常に作成されればOK' do
      plan = build(:plan, :planA)
      expect(plan.valid?).to eq(true)
    end

    it 'plan_codeが空だとNG' do
      plan = build(:plan, :planA)
      plan.plan_code = ''
      expect(plan.valid?).to eq(false)
    end

    it 'plan_nameが空だとNG' do
      plan = build(:plan, :planA)
      plan.plan_name = ''
      expect(plan.valid?).to eq(false)
    end

    it 'provider_codeが空だとNG' do
      plan = build(:plan, :planA)
      plan.provider_code = ''
      expect(plan.valid?).to eq(false)
    end

    it 'factoryのファイルが全て生成されていればOK' do
      create(:provider, :providerB)
      create(:provider, :providerC)
      create(:plan, :planA)
      create(:plan, :planB)
      create(:plan, :planC)
      plans = Plan.all
      expect(plans.size).to eq(3)
    end
  end
  describe'DB検索' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:basic_charge, :basicChargeA1)
      create(:commodity_charge, :commodityChargeA1)
    end
    it '該当データがあればOK' do
      records = Plan.select_plan.extraction_condition(10,100)
      expect(records.size).to eq(1)
    end
    it '該当するアンペアがない場合' do
      records = Plan.select_plan.extraction_condition(70,100)
      expect(records.size).to eq(0)
    end
    it '該当するkwhがない場合' do
      records = Plan.select_plan.extraction_condition(10,999999999)
      expect(records.size).to eq(0)
    end
  end
  describe 'record_to_hash' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:basic_charge, :basicChargeA1)
      create(:commodity_charge, :commodityChargeA1)
    end
    it '正常系' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      expect(records).to eq([{'plan_code'=>'PL000001','provider_name'=>'東京電力エナジーパートナー','plan_name'=>'従量電灯B','charge'=>286.00,'unit_price'=>19.88}])
    end
    it 'record_to_hashしていない場合' do
      records = Plan.select_plan.extraction_condition(10,100)
      expect(records).not_to eq([{'plan_code'=>'PL000001','provider_name'=>'東京電力エナジーパートナー','plan_name'=>'従量電灯B','charge'=>286.00,'unit_price'=>19.88}])
    end
  end
  describe 'calculate_step_price' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:basic_charge, :basicChargeA1)
      create(:commodity_charge, :commodityChargeA1)
    end
    it 'ハッシュ配列にstep_priceが追加されていればOK' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 100)
      expect(records[0]).to include('step_price')
    end
    it '正常に計算されていればOK' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 100)
      expect(records[0]['step_price']).to eq(1988)
    end
    it 'calculate_step_priceをしない場合step_priceが作成されない' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      expect(records[0]).not_to include('step_price')
    end
  end
  describe 'calculate_price' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:basic_charge, :basicChargeA1)
      create(:commodity_charge, :commodityChargeA1)
    end
    it 'ハッシュ配列にpriceが追加されていればOK' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 100)
      records = Plan.calculate_price(records)
      expect(records[0]).to include('price')
    end
    it '正常に計算されていればOK' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 100)
      records = Plan.calculate_price(records)
      expect(records[0]['price']).to eq(2274)
    end
    it 'calculate_priceをしない場合priceができない' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 100)
      expect(records[0]).not_to include('price')
    end
  end
  describe 'delete_key' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:basic_charge, :basicChargeA1)
      create(:commodity_charge, :commodityChargeA1)
    end
    it 'provider_name、plan、priceが存在していればOK' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 100)
      records = Plan.calculate_price(records)
      records = Plan.delete_key(records)
      expect(records[0]).to include('provider_name','plan_name','price')
    end
    it '正常系以外のキーが存在していたらNG' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 100)
      records = Plan.calculate_price(records)
      records = Plan.delete_key(records)
      expect(records[0]).not_to include('plan_code')
      expect(records[0]).not_to include('charge')
      expect(records[0]).not_to include('unit_price')
      expect(records[0]).not_to include('step_price')
    end
  end
  describe 'array_sort' do
    before do
      create(:provider, :providerA)
      create(:plan, :planA)
      create(:basic_charge, :basicChargeA1)
      create(:commodity_charge, :commodityChargeA1)
      create(:commodity_charge, :commodityChargeA2)
      create(:commodity_charge, :commodityChargeA3)
      create(:provider, :providerB)
      create(:plan, :planB)
      create(:basic_charge, :basicChargeB1)
      create(:commodity_charge, :commodityChargeB1)
    end
    it '正常にソートされていればOK' do
      records = Plan.select_plan.extraction_condition(10,1000)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 1000)
      records = Plan.calculate_price(records)
      records = Plan.delete_key(records)
      records = Plan.array_sort(records)
      expect(records[0]['plan_name']).to eq('おうちプラン') 
    end
    it '正常にソートされていればOK2' do
      records = Plan.select_plan.extraction_condition(10,100)
      records = Plan.record_to_hash(records)
      records = Plan.calculate_step_price(records, 100)
      records = Plan.calculate_price(records)
      records = Plan.delete_key(records)
      records = Plan.array_sort(records)
      expect(records[0]['plan_name']).to eq('従量電灯B') 
    end
    
  end
  
  
end
