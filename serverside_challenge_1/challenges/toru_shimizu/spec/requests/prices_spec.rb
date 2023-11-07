# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/prices' do
  let(:body) { response.parsed_body }

  data = YAML.load_file(Rails.root.join('db/seeds/prices.yaml'))
  service = PricesService.new

  describe 'GET /api/prices' do
    context 'リクエストパラメータが正常な場合' do
      it '200 OK が返ってくる' do
        get api_prices_path, params: { ampere: 10, volume: 300 }
        expect(response).to have_http_status(:ok)
      end

      it 'プランごとの電気料金を取得できる' do
        get api_prices_path, params: { ampere: 30, volume: 300 }

        expected = service.create_response(30, 300, data['companies'])
        expect(body).to eq(expected)
      end
    end

    context 'リクエストパラメータが不正な場合' do
      context 'ampere' do
        context '存在しない場合' do
          it '400 Bad Request が返ってくる' do
            get api_prices_path, params: { volume: 100 }
            expect(response).to have_http_status(400)
          end

          it 'アンペアは必須です とメッセージが返ってくる' do
            get api_prices_path, params: { volume: 100 }

            expect(body.length).to eq(1)
            expect(body[0]['message']).to eq('アンペアは必須です')
          end
        end

        context '契約可能な範囲外の場合' do
          it '400 Bad Request が返ってくる' do
            get api_prices_path, params: { ampere: 100, volume: 100 }
            expect(response).to have_http_status(400)
          end

          it '契約対象外のアンペアです とメッセージが返ってくる' do
            get api_prices_path, params: { ampere: 100, volume: 100 }

            expect(body.length).to eq(1)
            expect(body[0]['message']).to eq('契約対象外のアンペアです')
          end
        end
      end

      context 'volume' do
        context '存在しない場合' do
          it '400 Bad Request が返ってくる' do
            get api_prices_path, params: { ampere: 100 }
            expect(response).to have_http_status(400)
          end

          it '使用量は必須ですと メッセージが返ってくる' do
            get api_prices_path, params: { ampere: 10 }

            expect(body.length).to eq(1)
            expect(body[0]['message']).to eq('使用量は必須です')
          end
        end

        context '使用量が不正な値の場合' do
          context '負の数' do
            it '400 Bad Request が返ってくる' do
              get api_prices_path, params: { ampere: 10, volume: -100 }

              expect(response).to have_http_status(400)
            end

            it '使用量は0以上の値を入力してください とメッセージが返ってくる' do
              get api_prices_path, params: { ampere: 10, volume: -100 }

              expect(body.length).to eq(1)
              expect(body[0]['message']).to eq('使用量は0以上の値を入力してください')
            end
          end

          context '整数でない場合' do
            it '400 Bad Request が返ってくる' do
              get api_prices_path, params: { ampere: 10, volume: 10.10 }

              expect(response).to have_http_status(400)
            end

            it '使用量は整数で入力してください とメッセージが返ってくる' do
              get api_prices_path, params: { ampere: 10, volume: 10.10 }

              expect(body.length).to eq(1)
              expect(body[0]['message']).to eq('使用量は整数で入力してください')
            end
          end
        end
      end

      context 'ampere と volume が不正な値の場合' do
        context 'どちらも存在しない場合' do
          it '400 Bad Request が返ってくる' do
            get api_prices_path, params: { ampere: nil, volume: nil }

            expect(response).to have_http_status(400)
          end

          it 'アンペアは必須です と 使用量は必須です とメッセージが返ってくる' do
            get api_prices_path, params: { ampere: nil, volume: nil }

            expect(body.length).to eq(2)
            expect(body[0]['message']).to eq('アンペアは必須です')
            expect(body[1]['message']).to eq('使用量は必須です')
          end
        end

        context 'どちらも不正な値の場合' do
          context 'ampereが契約対象外 且つ使用量が負の数' do
            it '400 Bad Request が返ってくる' do
              get api_prices_path, params: { ampere: 100, volume: -100 }

              expect(response).to have_http_status(400)
            end
            it '契約対象外のアンペアです と 使用量は0以上の値を入力してください とメッセージが返ってくる' do
              get api_prices_path, params: { ampere: 100, volume: -100 }

              expect(body.length).to eq(2)
              expect(body[0]['message']).to eq('契約対象外のアンペアです')
              expect(body[1]['message']).to eq('使用量は0以上の値を入力してください')
            end
          end
          context 'ampereが契約対象外 且つ使用量が整数ではない' do
            it '400 Bad Request が返ってくる' do
              get api_prices_path, params: { ampere: 100, volume: 10.100 }

              expect(response).to have_http_status(400)
            end
            it '契約対象外のアンペアです と 使用量は整数で入力してください とメッセージが返ってくる' do
              get api_prices_path, params: { ampere: 100, volume: 10.100 }

              expect(body.length).to eq(2)
              expect(body[0]['message']).to eq('契約対象外のアンペアです')
              expect(body[1]['message']).to eq('使用量は整数で入力してください')
            end
          end
        end
      end
    end
  end
end
