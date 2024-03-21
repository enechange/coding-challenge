require 'rails_helper'

RSpec.describe Cost, type: :model do
  let(:valid_contract_ampere) { "30" }
  let(:valid_usage) { "100" }

  describe "バリデーション" do
    context "contract_ampere" do
      it "存在する場合、有効であること" do
        cost = Cost.new(contract_ampere: valid_contract_ampere, usage: valid_usage)
        expect(cost).to be_valid
      end

      it "存在しない場合、無効であること" do
        cost = Cost.new(contract_ampere: nil, usage: valid_usage)
        expect(cost).to_not be_valid
      end

      it "範囲内の値である場合、有効であること" do
        valid_values = %w(10 15 20 30 40 50 60)
        valid_values.each do |value|
          cost = Cost.new(contract_ampere: value, usage: valid_usage)
          expect(cost).to be_valid
        end
      end

      it "範囲外の値である場合、無効であること" do
        cost = Cost.new(contract_ampere: "5", usage: valid_usage)
        expect(cost).to_not be_valid
      end
    end

    context "usage" do
      it "存在する場合、有効であること" do
        cost = Cost.new(contract_ampere: valid_contract_ampere, usage: valid_usage)
        expect(cost).to be_valid
      end

      it "存在しない場合、無効であること" do
        cost = Cost.new(contract_ampere: valid_contract_ampere, usage: nil)
        expect(cost).to_not be_valid
      end

      it "0は有効であること" do
        cost = Cost.new(contract_ampere: valid_contract_ampere, usage: 0)
        expect(cost).to be_valid
      end
    end
  end

  describe "インスタンスメソッド" do
    context "calculate" do
      let(:cost) { Cost.new(contract_ampere: valid_contract_ampere, usage: valid_usage) }
      let(:rates) { cost.send(:yaml_data) }

      it "電力料金の計算結果が全データ数と一致すること" do
        calculated_costs = cost.calculate
        expect(calculated_costs.count).to eq(rates.count)

        calculated_costs.each_with_index do |calculated_cost, index|
          provider_key = rates.keys[index]
          expect(calculated_cost[:provider_name]).to eq(provider_key)
          expect(calculated_cost[:plan_name]).to eq(rates[provider_key]['plan_name'])
        end
      end

      it "使用量に対して、電力料金が計算されること" do
        cost.usage = "200"
        calculated_costs = cost.calculate
        expect(calculated_costs).not_to be_empty
      end

      it "大きな使用量に対して、電力料金が計算されること" do
        cost.usage = "10000"
        calculated_costs = cost.calculate
        expect(calculated_costs).not_to be_empty
      end

      it "contract_ampere および usage の値が不正な場合、空の配列を返すこと" do
        invalid_cost = Cost.new(contract_ampere: "5", usage: "-10")
        calculated_costs = invalid_cost.calculate
        expect(calculated_costs).to be_empty
      end
    end
  end
end
