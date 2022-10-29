require 'rails_helper'

RSpec.describe 'ElectricityRatePlans', type: :request do
  let(:body) { JSON.parse(response.body) }

  describe 'GET /electricity_rate_plans' do
    describe '成功' do
      describe '契約アンペア数の増加確認' do
        context '契約アンペア数10A、電気使用量100kWhの場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 100 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"
            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 2274
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 2640
                                  }
                              ])
          end
        end

        context '契約アンペア数15A、電気使用量100kWhの場合' do
          let(:contract_amperage) { 15 }
          let(:electricity_usage) { 100 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 2417
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 2640
                                  }
                              ])
          end
        end

        context '契約アンペア数20A、電気使用量100kWhの場合' do
          let(:contract_amperage) { 20 }
          let(:electricity_usage) { 100 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 2560
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 2640
                                  }
                              ])
          end
        end

        context '契約アンペア数30A、電気使用量100kWhの場合' do
          let(:contract_amperage) { 30 }
          let(:electricity_usage) { 100 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(4)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 2846
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 2640
                                  },
                                  {
                                    'provider_name' => '東京ガス',
                                    'plan_name' => 'ずっとも電気1',
                                    'price' => 3225
                                  },
                                  {
                                    'provider_name' => 'JXTGでんき',
                                    'plan_name' => '従量電灯Bたっぷりプラン',
                                    'price' => 2846
                                  }
                                ])
          end
        end

        context '契約アンペア数40A、電気使用量100kWhの場合' do
          let(:contract_amperage) { 40 }
          let(:electricity_usage) { 100 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(4)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 3132
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 2640
                                  },
                                  {
                                    'provider_name' => '東京ガス',
                                    'plan_name' => 'ずっとも電気1',
                                    'price' => 3511
                                  },
                                  {
                                    'provider_name' => 'JXTGでんき',
                                    'plan_name' => '従量電灯Bたっぷりプラン',
                                    'price' => 3132
                                  }
                                ])
          end
        end

        context '契約アンペア数50A、電気使用量100kWhの場合' do
          let(:contract_amperage) { 50 }
          let(:electricity_usage) { 100 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(4)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 3418
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 2640
                                  },
                                  {
                                    'provider_name' => '東京ガス',
                                    'plan_name' => 'ずっとも電気1',
                                    'price' => 3797
                                  },
                                  {
                                    'provider_name' => 'JXTGでんき',
                                    'plan_name' => '従量電灯Bたっぷりプラン',
                                    'price' => 3418
                                  }
                                ])
          end
        end

        context '契約アンペア数60A、電気使用量100kWhの場合' do
          let(:contract_amperage) { 60 }
          let(:electricity_usage) { 100 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(4)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 3704
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 2640
                                  },
                                  {
                                    'provider_name' => '東京ガス',
                                    'plan_name' => 'ずっとも電気1',
                                    'price' => 4083
                                  },
                                  {
                                    'provider_name' => 'JXTGでんき',
                                    'plan_name' => '従量電灯Bたっぷりプラン',
                                    'price' => 3704
                                  }
                                ])
          end
        end
      end

      describe '使用量(kWh)の増加確認' do
        context '契約アンペア数10A、電気使用量0kWhの場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 0 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 286
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 0
                                  },
                                ])
          end
        end

        context '契約アンペア数10A、電気使用量50kWhの場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 50 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 1280
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 1320
                                  },
                                ])
          end
        end

        context '契約アンペア数10A、電気使用量100kWhの場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 100 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 2274
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 2640
                                  },
                                ])
          end
        end

        context '契約アンペア数10A、電気使用量200kWhの場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 200 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 4790
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 5280
                                  },
                                ])
          end
        end

        context '契約アンペア数10A、電気使用量300kWhの場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 300 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 7438
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 7920
                                  },
                                ])
          end
        end

        context '契約アンペア数10A、電気使用量400kWhの場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 400 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 10495
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 10560
                                  },
                                ])
          end
        end

        context '契約アンペア数10A、電気使用量500kWhの場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 500 }

          it 'プラン情報が正しく取得できる' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(200)
            expect(body.count).to eq(2)
            expect(body).to eq([
                                  {
                                    'provider_name' => '東京電力エナジーパートナー',
                                    'plan_name' => '従量電灯B',
                                    'price' => 13552
                                  },
                                  {
                                    'provider_name' => 'Loopでんき',
                                    'plan_name' => 'おうちプラン',
                                    'price' => 13200
                                  },
                                ])
          end
        end
      end
    end

    describe '失敗' do
      describe '契約アンペア数' do
        context '未入力の場合' do
          let(:contract_amperage) { '' }
          let(:electricity_usage) { 400 }

          it '未入力及び入力条件に関するエラーメッセージを返すこと' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(400)
            expect(body['errors']).to eq({'contract_amperage' => ['未入力です。','[10, 15, 20, 30, 40, 50, 60]内、いずれかの数値を入力してください。']})
          end
        end

        context '文字列の場合' do
          let(:contract_amperage) { 'contract_amperage' }
          let(:electricity_usage) { 400 }

          it '入力条件に関するエラーメッセージを返す' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(400)
            expect(body['errors']).to eq({'contract_amperage' => ['[10, 15, 20, 30, 40, 50, 60]内、いずれかの数値を入力してください。']})
          end
        end

        context '入力条件(10,15,20,30,40,50,60)に該当しない場合' do
          let(:contract_amperage) { 1000 }
          let(:electricity_usage) { 400 }

          it '入力条件に関するエラーメッセージを返す' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(400)
            expect(body['errors']).to eq({'contract_amperage' => ['[10, 15, 20, 30, 40, 50, 60]内、いずれかの数値を入力してください。']})
          end
        end
      end

      describe '電気使用量' do
        context '未入力の場合' do
          let(:contract_amperage) { 20 }
          let(:electricity_usage) { '' }

          it '未入力及び入力条件に関するエラーメッセージを返す' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(400)
            expect(body['errors']).to eq({'electricity_usage' => ['未入力です。','正の整数を入力してください。']})
          end
        end

        context '文字列の場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 'electricity_usage' }

          it '入力条件に関するエラーメッセージを返す' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(400)
            expect(body['errors']).to eq({'electricity_usage' => ['正の整数を入力してください。']})
          end
        end

        context 'マイナス値の場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { -1 }

          it '入力条件に関するエラーメッセージを返す' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(400)
            expect(body['errors']).to eq({'electricity_usage' => ['正の整数を入力してください。']})
          end
        end

        context '少数の場合' do
          let(:contract_amperage) { 10 }
          let(:electricity_usage) { 0.1 }

          it '入力条件に関するエラーメッセージを返す' do
            get "/api/electricity_rate_plans?contract_amperage=#{contract_amperage}&electricity_usage=#{electricity_usage}"

            expect(response.status).to eq(400)
            expect(body['errors']).to eq({'electricity_usage' => ['正の整数を入力してください。']})
          end
        end
      end
    end
  end
end
