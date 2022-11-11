require 'rails_helper'
require 'support/suggest_helper'

RSpec.describe 'Suggests', type: :request do
  describe 'GET /api/v1/suggests' do
    let(:body){ JSON.parse(response.body) }
    let(:path){ "/api/v1/suggests?A=#{amp}&kWh=#{kwh}" }

    before do
      # テストデータの挿入
      post '/api/v1/providers', params: {file: fixture_file_upload('providers.csv')}
      post '/api/v1/plans', params: {file: fixture_file_upload('plans.csv')}
      post '/api/v1/amperages', params: {file: fixture_file_upload('amperages.csv')}
      post '/api/v1/kilowattos', params: {file: fixture_file_upload('kilowattos.csv')}
    end


    describe '成功' do
      describe 'アンペア数変更時の動作確認' do
        # kWhは10kWhで固定
        let(:kwh){ 10 }

        context '10Aの場合' do
          let(:amp){ 10 }
          it '正しいプラン情報が取得できる' do
            get path

            expect(response).to be_successful
            expect(body).to eq([
              {
                  "provider_name"=>"東京電力エナジーパートナー",
                  "plan_name"=>"従量電灯B",
                  "price"=>485
              },
              {
                  "provider_name"=>"Loopでんき",
                  "plan_name"=>"おうちプラン",
                  "price"=>264
              }
          ])
          end
        end

        context '15Aの場合' do
          let(:amp){ 15 }
          it '正しいプラン情報が取得できる' do
            get path

            expect(response).to be_successful
            expect(body).to eq([
              {
                  "provider_name"=>"東京電力エナジーパートナー",
                  "plan_name"=>"従量電灯B",
                  "price"=>628
              }
          ])
          end
        end

        context '20Aの場合' do
          let(:amp){ 20 }
          it '正しいプラン情報が取得できる' do
            get path

            expect(response).to be_successful
            expect(body).to eq([
              {
                  "provider_name"=>"東京電力エナジーパートナー",
                  "plan_name"=>"従量電灯B",
                  "price"=>771
              },
              {
                  "provider_name"=>"Loopでんき",
                  "plan_name"=>"おうちプラン",
                  "price"=>264
              }
          ])
          end
        end

        context '30Aの場合' do
          let(:amp){ 30 }
          it '正しいプラン情報が取得できる' do
            get path

            expect(response).to be_successful
            expect(body).to eq([
              {
                  "provider_name"=>"東京電力エナジーパートナー",
                  "plan_name"=>"従量電灯B",
                  "price"=>1057
              },
              {
                  "provider_name"=>"Loopでんき",
                  "plan_name"=>"おうちプラン",
                  "price"=>264
              },
              {
                  "provider_name"=>"東京ガス",
                  "plan_name"=>"ずっとも電気1",
                  "price"=>1095
              },
              {
                  "provider_name"=>"JXTGでんき",
                  "plan_name"=>"従量電灯Bたっぷりプラン",
                  "price"=>1057
              }
          ])
          end
        end

        context '40Aの場合' do
          let(:amp){ 40 }
          it '正しいプラン情報が取得できる' do
            get path

            expect(response).to be_successful
            expect(body).to eq([
              {
                  "provider_name"=>"東京電力エナジーパートナー",
                  "plan_name"=>"従量電灯B",
                  "price"=>1343
              },
              {
                  "provider_name"=>"Loopでんき",
                  "plan_name"=>"おうちプラン",
                  "price"=>264
              },
              {
                  "provider_name"=>"東京ガス",
                  "plan_name"=>"ずっとも電気1",
                  "price"=>1381
              },
              {
                  "provider_name"=>"JXTGでんき",
                  "plan_name"=>"従量電灯Bたっぷりプラン",
                  "price"=>1343
              }
          ])
          end
        end

        context '50Aの場合' do
          let(:amp){ 50 }
          it '正しいプラン情報が取得できる' do
            get path

            expect(response).to be_successful
            expect(body).to eq([
              {
                  "provider_name"=>"東京電力エナジーパートナー",
                  "plan_name"=>"従量電灯B",
                  "price"=>1629
              },
              {
                  "provider_name"=>"Loopでんき",
                  "plan_name"=>"おうちプラン",
                  "price"=>264
              },
              {
                  "provider_name"=>"東京ガス",
                  "plan_name"=>"ずっとも電気1",
                  "price"=>1667
              },
              {
                  "provider_name"=>"JXTGでんき",
                  "plan_name"=>"従量電灯Bたっぷりプラン",
                  "price"=>1629
              }
          ])
          end
        end

        context '60Aの場合' do
          let(:amp){ 60 }
          it '正しいプラン情報が取得できる' do
            get path

            expect(response).to be_successful
            expect(body).to eq([
              {
                  "provider_name"=>"東京電力エナジーパートナー",
                  "plan_name"=>"従量電灯B",
                  "price"=>1915
              },
              {
                  "provider_name"=>"Loopでんき",
                  "plan_name"=>"おうちプラン",
                  "price"=>264
              },
              {
                  "provider_name"=>"東京ガス",
                  "plan_name"=>"ずっとも電気1",
                  "price"=>1953
              },
              {
                  "provider_name"=>"JXTGでんき",
                  "plan_name"=>"従量電灯Bたっぷりプラン",
                  "price"=>1915
              }
          ])
          end
        end

      end
    end

    describe '失敗' do
      describe 'A数誤入力時の動作確認' do
        # kWhは10kWhで固定
        let(:kwh){ 10 }

        context '予期しないA数が入力された場合' do
          let(:amp){ 5 }
          include_examples 'Aのエラーメッセージを返す'
        end

        context '文字列が入力された場合' do
          let(:amp){ 'test' }
          include_examples 'Aのエラーメッセージを返す'
        end
      end
    end
  end
end
