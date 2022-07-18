# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ElectricityRatePlans', type: :request do
  describe 'GET /electricity_rate_plans' do
    context 'リクエストに含まれる契約アンペア数,電気使用量が正常な値の場合' do
      it 'プラン情報が正しく取得できる' do
        ampere = 30
        usage = 400

        get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([
                                                  {
                                                    'provider_name' => '東京電力エナジーパートナー',
                                                    'plan_name' => '従量電灯B',
                                                    'price' => 11_067
                                                  },
                                                  {
                                                    'provider_name' => 'Loopでんき',
                                                    'plan_name' => 'おうちプラン',
                                                    'price' => 10_560
                                                  },
                                                  {
                                                    'provider_name' => '東京ガス',
                                                    'plan_name' => 'ずっとも電気1',
                                                    'price' => 10_507
                                                  },
                                                  {
                                                    'provider_name' => 'JXTGでんき',
                                                    'plan_name' => '従量電灯Bたっぷりプラン',
                                                    'price' => 10_518
                                                  }
                                                ])
      end

      context '基本料金の計算結果の確認（東京電力エナジーを参照）' do
        let(:electricity_usage) { 100 }

        context '契約アンペア数10A,電気使用量100kWhの場合' do
          it '電気料金は2274円となる' do
            ampere = 10

            get "/api/electricity_rate_plans?contract_amperage=#{ampere}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 2274
                                                         })
          end
        end
        context '契約アンペア数15A,電気使用量100kWhの場合' do
          it '電気料金は2417円となる' do
            ampere = 15

            get "/api/electricity_rate_plans?contract_amperage=#{ampere}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 2417
                                                         })
          end
        end
        context '契約アンペア数20A,電気使用量100kWhの場合' do
          it '電気料金は2560円となる' do
            ampere = 20

            get "/api/electricity_rate_plans?contract_amperage=#{ampere}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 2560
                                                         })
          end
        end
        context '契約アンペア数30A,電気使用量100kWhの場合' do
          it '電気料金は2846円となる' do
            ampere = 30

            get "/api/electricity_rate_plans?contract_amperage=#{ampere}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 2846
                                                         })
          end
        end
        context '契約アンペア数40A,電気使用量100kWhの場合' do
          it '電気料金は3132円となる' do
            ampere = 40

            get "/api/electricity_rate_plans?contract_amperage=#{ampere}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 3132
                                                         })
          end
        end
        context '契約アンペア数50A,電気使用量100kWhの場合' do
          it '電気料金は3418円となる' do
            ampere = 50

            get "/api/electricity_rate_plans?contract_amperage=#{ampere}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 3418
                                                         })
          end
        end
        context '契約アンペア数60A,電気使用量100kWhの場合' do
          it '電気料金は3704円となる' do
            ampere = 60

            get "/api/electricity_rate_plans?contract_amperage=#{ampere}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 3704
                                                         })
          end
        end
      end

      context '従量料金の計算結果の確認（東京電力エナジーを参照）' do
        let(:contract_amperage) { 10 }

        context '契約アンペア数10A,電気使用量1kWhの場合' do
          it '電気料金は305円となる' do
            usage = 1

            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 305
                                                         })
          end
        end

        context '契約アンペア数10A,電気使用量120kWhの場合' do
          it '電気料金は2671円となる' do
            usage = 120

            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 2671
                                                         })
          end
        end

        context '契約アンペア数10A,電気使用量121kWhの場合' do
          it '電気料金は2698円となる' do
            usage = 121

            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 2698
                                                         })
          end
        end

        context '契約アンペア数10A,電気使用量300kWhの場合' do
          it '電気料金は7438円となる' do
            usage = 300

            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 7438
                                                         })
          end
        end

        context '契約アンペア数10A,電気使用量301kWhの場合' do
          it '電気料金は7468円となる' do
            usage = 301

            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{usage}"

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to include({
                                                           'provider_name' => '東京電力エナジーパートナー',
                                                           'plan_name' => '従量電灯B',
                                                           'price' => 7468
                                                         })
          end
        end
      end

      context 'リクエストに含まれる契約アンペア数を提供していないプランが表示されないことの確認' do
        context '契約アンペア数20Aの場合' do
          it '契約アンペア数20Aを提供しているプラン数とレスポンスのプラン数が合致している' do
            ampere = 20
            usage = 200
            plans = ElectricityRatePlan.eager_load(:basic_charges)
                                       .where(basic_charges: { contract_amperage: ampere })

            get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body).count).to eq(plans.count)
          end

          it '「ずっとも電気1」プランはレスポンスに含まれない' do
            ampere = 20
            usage = 200

            get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

            result = JSON.parse(response.body).find do |content|
              content['plan_name'] == 'ずっとも電気1'
            end
            expect(response.status).to eq(200)
            expect(result).to be nil
          end
        end
      end
    end

    context 'リクエストに含まれる契約アンペア数,電気使用量が不正な値の場合' do
      context '契約アンペア数が未入力の場合' do
        it '未入力及び入力条件に関するエラーメッセージを返す' do
          ampere = ''
          usage = 400

          get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)['errors']).to eq({
                                                              'contract_amperage' => [
                                                                '未入力です。',
                                                                '[10, 15, 20, 30, 40, 50, 60]内、いずれかの数値を入力してください。'
                                                              ]
                                                            })
        end
      end

      context '契約アンペア数が文字列の場合' do
        it '入力条件に関するエラーメッセージを返す' do
          ampere = 'test'
          usage = 400

          get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)['errors']).to eq({
                                                              'contract_amperage' => [
                                                                '[10, 15, 20, 30, 40, 50, 60]内、いずれかの数値を入力してください。'
                                                              ]
                                                            })
        end
      end

      context '契約アンペア数が入力条件に該当しない数値の場合' do
        it '入力条件に関するエラーメッセージを返す' do
          ampere = 1000
          usage = 400

          get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)['errors']).to eq({
                                                              'contract_amperage' => [
                                                                '[10, 15, 20, 30, 40, 50, 60]内、いずれかの数値を入力してください。'
                                                              ]
                                                            })
        end
      end

      context '電気使用量が未入力の場合' do
        it '未入力及び入力条件に関するエラーメッセージを返す' do
          ampere = 10
          usage = ''

          get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)['errors']).to eq({
                                                              'electricity_usage' => [
                                                                '未入力です。',
                                                                '0以上、99999以下の整数を入力してください。'
                                                              ]
                                                            })
        end
      end

      context '電気使用量が文字列の場合' do
        it '入力条件に関するエラーメッセージを返す' do
          ampere = 10
          usage = 'test'

          get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)['errors']).to eq({
                                                              'electricity_usage' => [
                                                                '0以上、99999以下の整数を入力してください。'
                                                              ]
                                                            })
        end
      end

      context '電気使用量が入力条件に該当しない数値の場合' do
        it '入力条件に関するエラーメッセージを返す' do
          ampere = 10
          usage = -1

          get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)['errors']).to eq({
                                                              'electricity_usage' => [
                                                                '0以上、99999以下の整数を入力してください。'
                                                              ]
                                                            })
        end
      end

      context '電気使用量が少数の場合' do
        it '入力条件に関するエラーメッセージを返す' do
          ampere = 10
          usage = 0.1

          get api_electricity_rate_plans_path(contract_amperage: ampere, electricity_usage: usage)

          expect(response.status).to eq(400)
          expect(JSON.parse(response.body)['errors']).to eq({
                                                              'electricity_usage' => [
                                                                '0以上、99999以下の整数を入力してください。'
                                                              ]
                                                            })
        end
      end
    end
  end
end
