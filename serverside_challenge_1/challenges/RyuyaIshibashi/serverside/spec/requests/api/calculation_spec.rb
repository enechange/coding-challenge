require 'rails_helper'

RSpec.describe "Calculations", type: :request do

  describe 'CalculationAPI' do
    let (:response_body) { response.body }
    let (:response_status) { response.status }

    context "正常系" do
      context '取得データ0件の場合' do
        before do
          get '/api/calculation?ampere=10&amount=10'
        end

        it "正しいレスポンスボディを返却すること" do
          ok_body = ok_body([])
          expect(response_body).to eq(ok_body)
        end

        it "HTTPステータスコードが200 OKとなること" do
          expect(response_status).to eq(200)
        end
      end

      context '取得データ1件の場合' do
        let! (:company) { FactoryBot.create(:company, name: "会社") }  
        let! (:plan) { FactoryBot.create(:plan_itself, name: "プラン", company: company) }
        let! (:basic_fee) { FactoryBot.create(:basic_fee_itself, plan: plan, ampere: "10.00", fee: "12.34") }
        let! (:usage_charge) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "0.00", to: nil, unit_price: "34.56") }

        before do
          get '/api/calculation?ampere=10&amount=80'
        end
        
        it "正しいレスポンスボディを返却すること" do
          ok_body = ok_body([simulation_result("会社", "プラン", 2777)]) #12.34 + 34.56 * 80
          expect(response_body).to eq(ok_body)
        end

        it "HTTPステータスコードが200 OKとなること" do
          expect(response_status).to eq(200)
        end
      end

      context '取得データN件の場合' do
        let! (:company_1) { FactoryBot.create(:company, id: 1, name: "会社_1") }  
        let! (:company_2) { FactoryBot.create(:company, id: 2, name: "会社_2") }  
        let! (:company_3) { FactoryBot.create(:company, id: 3, name: "会社_3") }  

        let! (:plan_1) { FactoryBot.create(:plan_itself, company: company_1, name: "プラン_1") }
        let! (:plan_2) { FactoryBot.create(:plan_itself, company: company_2, name: "プラン_2") }
        let! (:plan_3) { FactoryBot.create(:plan_itself, company: company_3, name: "プラン_3") }

        before do
          # プラン_1 基本料金
          FactoryBot.create(:basic_fee_itself, plan: plan_1, ampere: "10.00", fee: "1234.56")
          FactoryBot.create(:basic_fee_itself, plan: plan_1, ampere: "20.00", fee: "7890.12")
  
          # プラン_2 基本料金
          FactoryBot.create(:basic_fee_itself, plan: plan_2, ampere: "10.00", fee: "3456.78")
          FactoryBot.create(:basic_fee_itself, plan: plan_2, ampere: "20.00", fee: "9012.34")
  
          # プラン_3 基本料金
          FactoryBot.create(:basic_fee_itself, plan: plan_3, ampere: "10.00", fee: "5678.90")
          FactoryBot.create(:basic_fee_itself, plan: plan_3, ampere: "20.00", fee: "1234.56")
  
          # プラン_1 従量料金
          FactoryBot.create(:usage_charge_itself, plan: plan_1, from: "0.00", to: nil, unit_price: "1234.56")
  
          # プラン_2 従量料金
          FactoryBot.create(:usage_charge_itself, plan: plan_2, from: "34.56", to: "45.67", unit_price: "1234.56")
          FactoryBot.create(:usage_charge_itself, plan: plan_2, from: "45.67", to: nil, unit_price: "2345.67")
  
          # プラン_3 従量料金
          FactoryBot.create(:usage_charge_itself, plan: plan_3, from: "0.00", to: "12.34", unit_price: "1234.56")
          FactoryBot.create(:usage_charge_itself, plan: plan_3, from: "12.34", to: "23.45", unit_price: "2345.67")
          FactoryBot.create(:usage_charge_itself, plan: plan_3, from: "23.45", to: "34.56", unit_price: "3456.78")
          FactoryBot.create(:usage_charge_itself, plan: plan_3, from: "34.56", to: nil, unit_price: "4567.89")

          get '/api/calculation?ampere=20&amount=30'
        end
        
        it "正しいレスポンスボディを返却すること" do
          ok_body = ok_body([
            simulation_result("会社_1", "プラン_1", 44926), # 7890.12 + (1234.56 * 30)
            simulation_result("会社_3", "プラン_3", 65171)  # 1234.56 + (1234.56 * 12.34) + (2345.67 * (23.45 - 12.34)) + (3456.78 * (30 - 23.45))
          ])
          expect(response_body).to eq(ok_body)
        end

        it "HTTPステータスコードが200 OKとなること" do
          expect(response_status).to eq(200)
        end
      end
    end

    context "異常系" do
      context "BadRequest" do
        context '契約アンペア数が不正の場合' do
          before do
            get '/api/calculation?ampere=&amount=10'
          end
          
          it "正しいレスポンスボディを返却すること" do
            bad_body = bad_parameter_body('契約アンペア数')
            expect(response_body).to eq(bad_body)
          end
  
          it "HTTPステータスコードが200 OKとなること" do
            expect(response_status).to eq(400)
          end
        end

        context '使用料が不正の場合' do
          before do
            get '/api/calculation?ampere=10&amount='
          end
          
          it "正しいレスポンスボディを返却すること" do
            bad_body = bad_parameter_body('使用料')
            expect(response_body).to eq(bad_body)
          end
  
          it "HTTPステータスコードが400 Bad Requestとなること" do
            expect(response_status).to eq(400)
          end
        end
      end

      context "Internal Server Error" do
        before do
          # 内部のメソッドで例外を発生
          allow(CalculationService).to receive(:valid_ampere?).and_raise(StandardError, "hogehoge")  
          get '/api/calculation?ampere=10&amount=10'
        end

        context '例外が発生する場合' do
          it "正しいレスポンスボディを返却すること" do
            exception_body = exception_body()
            expect(response_body).to eq(exception_body)
          end

          it "HTTPステータスコードが500 Internal Server Errorとなること" do
            expect(response_status).to eq(500)
          end
        end
      end
    end
  end
end
