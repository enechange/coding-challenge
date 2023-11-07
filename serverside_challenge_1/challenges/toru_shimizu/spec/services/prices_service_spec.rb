# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PricesService do
  data = YAML.load_file(Rails.root.join('db/seeds/prices.yaml'))
  service = described_class.new

  describe '基本料金の計算' do
    plans = data['companies'][0]['plans'][0]['basics']

    context '契約可能なアンペア数の場合' do
      it 'アンペア数に紐づく基本料金が返却される' do
        basic_price = plans.find { |basic| basic['ampere'].to_i == 10 }

        expect(service.caluculate_basic(10, plans)).to eq(basic_price['price'])
      end
    end
    context '契約不可能なアンペア数の場合' do
      it 'アンペア数に紐づく基本料金が返却される' do
        basic_price = plans.find { |basic| basic['ampere'].to_i == 70 }

        expect(service.caluculate_basic(70, plans)).to be_nil
        expect(basic_price).to be_nil
      end
    end
  end

  describe '従量料金の計算' do
    context '使用量に関わらず料金単価が一律の場合' do
      it '使用量 * 料金単価の結果が返却される' do
        plan = { 'min' => 0, 'max' => nil, 'price' => 100 }
        volume = 300
        expected = volume * plan['price']

        expect(service.caluculate_volume(volume, [plan])).to eq(expected)
      end
    end

    context '使用量に応じて料金単価が変動する場合' do
      plan_one = { 'min' => 0, 'max' => 120, 'price' => 100 }
      plan_two = { 'min' => 120, 'max' => 300, 'price' => 200 }
      plan_three = { 'min' => 300, 'max' => nil, 'price' => 300 }
      plans = [plan_one, plan_two, plan_three]

      context '1段階目の料金単価で収まる使用量の場合' do
        it '使用量 * 1段階目の料金単価の結果が返却される' do
          volume = 100
          expected = volume * plan_one['price']

          expect(service.caluculate_volume(volume, plans)).to eq(expected)
        end
      end

      context '料金単価の境界値にあたる使用量の場合' do
        it '使用量 * 低い方の段階の料金単価の結果が返却される' do
          volume = plan_one['max']
          expected = volume * plan_one['price']

          expect(service.caluculate_volume(volume, plans)).to eq(expected)
        end
      end

      context '2段階以上の料金単価で計算される使用量の場合' do
        it '使用量に応じた料金単価で計算されて返却される' do
          volume = 150
          price_one = plan_one['max'] * plan_one['price']
          price_two = (volume - plan_two['min']) * plan_two['price']
          expected = price_one + price_two

          expect(service.caluculate_volume(volume, plans)).to eq(expected)
        end
      end

      context '2段階以上の料金単価で計算される使用量の場合' do
        it '使用量に応じた料金単価で計算されて返却される' do
          volume = 150
          price_one = plan_one['max'] * plan_one['price']
          price_two = (volume - plan_two['min']) * plan_two['price']
          expected = price_one + price_two

          expect(service.caluculate_volume(volume, plans)).to eq(expected)
        end
      end

      context '2段階以上の料金単価で計算される使用量の場合' do
        it '使用量に応じた料金単価で計算され、合計値が返却される' do
          volume = 150
          price_one = plan_one['max'] * plan_one['price']
          price_two = (volume - plan_two['min']) * plan_two['price']
          expected = price_one + price_two

          expect(service.caluculate_volume(volume, plans)).to eq(expected)
        end
      end

      context 'プラン内に設定されている料金単価の最大値まで到達した使用量の場合' do
        it '最大値に到達以降は最大の料金単価 * 使用量で計算され、合計値が返却される' do
          volume = 1000
          price_one = plan_one['max'] * plan_one['price']
          price_two = (plan_two['max'] - plan_two['min']) * plan_two['price']
          price_three = (volume - plan_two['max']) * plan_three['price']

          expected = price_one + price_two + price_three

          expect(service.caluculate_volume(volume, plans)).to eq(expected)
        end
      end
    end
  end

  describe 'レスポンスの生成' do
    companies = data['companies']

    context '契約可能なアンペア数の場合' do
      it 'レスポンスが生成される' do
        ampere = 10
        volume = 120

        expected = [{ 'provider_name' => '東京電力エナジーパートナー', 'plan_name' => '従量電灯B', 'price' => 2671 },
                    { 'provider_name' => 'Loopでんき', 'plan_name' => 'おうちプラン', 'price' => 3168 }]

        expect(service.create_response(ampere, volume, companies)).to eq(expected)
      end
    end

    context '契約不可能なアンペア数の場合' do
      it 'レスポンスが生成されない' do
        ampere = 70
        volume = 120

        expect(service.create_response(ampere, volume, companies)).to eq([])
      end
    end
  end

  describe 'パラメータのバリデーション' do
    context 'エラーがない場合' do
      it '空の配列が返却される' do
        result = service.validate_params({ ampere: '10', volume: '100' })
        expect(result).to be_empty
      end
    end
    context 'アンペア' do
      context '存在しない場合' do
        it '"アンペアは必須です" とメッセージが返却される' do
          result = service.validate_params({ ampere: nil, volume: '100' })

          expect(result.length).to eq(1)
          expect(result[0]['message']).to eq('アンペアは必須です')
        end
      end

      context '契約対象外のアンペアの場合' do
        it '"契約対象外のアンペアです" とメッセージが返却される' do
          result = service.validate_params({ ampere: '100', volume: '100' })

          expect(result.length).to eq(1)
          expect(result[0]['message']).to eq('契約対象外のアンペアです')
        end
      end
    end

    context '使用量' do
      context '存在しない場合' do
        it '"使用量は必須です" とメッセージが返却される' do
          result = service.validate_params({ ampere: '10', volume: nil })

          expect(result.length).to eq(1)
          expect(result[0]['message']).to eq('使用量は必須です')
        end
      end

      context '負の整数の場合' do
        it '"使用量は0以上の値を入力してください" とメッセージが返却される' do
          result = service.validate_params({ ampere: '10', volume: '-10' })

          expect(result.length).to eq(1)
          expect(result[0]['message']).to eq('使用量は0以上の値を入力してください')
        end
      end

      context '整数ではない場合' do
        it '"使用量は整数で入力してください" とメッセージが返却される' do
          result = service.validate_params({ ampere: '10', volume: '10.10' })

          expect(result.length).to eq(1)
          expect(result[0]['message']).to eq('使用量は整数で入力してください')
        end
      end
    end

    context 'アンペアと使用量の両方が不正な場合' do
      context '両方とも存在しない場合' do
        it '"アンペアは必須です" と "使用量は必須です" とメッセージが返却される' do
          result = service.validate_params({ ampere: nil, volume: nil })

          expect(result.length).to eq(2)
          expect(result[0]['message']).to eq('アンペアは必須です')
          expect(result[1]['message']).to eq('使用量は必須です')
        end
      end

      context '契約対象外のアンペアと使用量が整数ではない場合' do
        it '"契約対象外のアンペアです" と "使用量は整数で入力してください" とメッセージが返却される' do
          result = service.validate_params({ ampere: '100', volume: '100.100' })

          expect(result.length).to eq(2)
          expect(result[0]['message']).to eq('契約対象外のアンペアです')
          expect(result[1]['message']).to eq('使用量は整数で入力してください')
        end
      end
    end
  end
end
