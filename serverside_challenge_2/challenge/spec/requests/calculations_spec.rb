# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe 'Calculations', type: :request do
  describe 'GET /api/calculation_fee' do
    context 'パラメータが両方とも未入力な場合' do
      let(:ampere) { nil }
      let(:usage) { nil }
      it 'エラーになり、金額が取得できないこと' do
        get api_calculation_fee_path, params: { ampere:, usage: }
        expect(response).to have_http_status(400)
        expect(response.body).to include '契約アンペア数が入力されていません'
      end
    end

    context 'パラメータが片方だけ正しい値の場合' do
      describe '契約アンペア数' do
        let(:usage) { nil }

        context '数値のみで入力されている場合' do
          let(:ampere) { 10 }

          it 'エラーになり、金額が取得できないこと' do
            get api_calculation_fee_path, params: { ampere:, usage: }
            expect(response).to have_http_status(400)
            expect(response.body).to include '電気使用量が入力されていません'
          end
        end

        context '文字列が入力されている場合' do
          let(:ampere) { 'test' }

          it 'エラーになり、金額が取得できないこと' do
            get api_calculation_fee_path, params: { ampere:, usage: }
            expect(response).to have_http_status(400)
            expect(response.body).to include '契約アンペア数に不正な値が設定されています'
          end
        end

        context '数値と文字列が入力されている場合' do
          let(:ampere) { '123test' }

          it 'エラーになり、金額が取得できないこと' do
            get api_calculation_fee_path, params: { ampere:, usage: }
            expect(response).to have_http_status(400)
            expect(response.body).to include '契約アンペア数に不正な値が設定されています'
          end
        end

        context '想定外の数値が入力されている場合' do
          let(:ampere) { %w[100 1].sample }

          it 'エラーになり、金額が取得できないこと' do
            get api_calculation_fee_path, params: { ampere:, usage: }
            expect(response).to have_http_status(400)
            expect(response.body).to include '契約アンペア数に不正な値が設定されています'
          end
        end
      end

      describe '電気使用量' do
        let(:ampere) { 30 }

        context '未入力の場合' do
          let(:usage) { nil }

          it 'エラーになり、金額が取得できないこと' do
            get api_calculation_fee_path, params: { ampere:, usage: }
            expect(response).to have_http_status(400)
            expect(response.body).to include '電気使用量が入力されていません'
          end
        end

        context '文字列が入力されている場合' do
          let(:usage) { 'test' }

          it 'エラーになり、金額が取得できないこと' do
            get api_calculation_fee_path, params: { ampere:, usage: }
            expect(response).to have_http_status(400)
            expect(response.body).to include '電気使用量が指定されておりません'
          end
        end

        context '数値と文字列が入力されている場合' do
          let(:usage) { '123test' }

          it 'エラーになり、金額が取得できないこと' do
            get api_calculation_fee_path, params: { ampere:, usage: }
            expect(response).to have_http_status(400)
            expect(response.body).to include '電気使用量が指定されておりません'
          end
        end
      end
    end

    context 'どちらも正しいパラメータが入力されている場合' do
      let(:ampere) { 20 }
      let(:usage) { 100 }
      let(:plan) { create(:plan) }

      before do
        create(:basic_monthly_fee, contract_amperage: 20, plan:)
        create(:electricity_usage, plan:, from: 1, to: 100, unit_price: 140.05)
      end

      it 'エラーとならず、正しい金額が取得できること' do
        get api_calculation_fee_path, params: { ampere:, usage: }
        expect(response).to have_http_status(200)
        result = JSON.parse(response.body, symbolize_names: true)
        expected_value = { providerName: plan.provider.name, planName: plan.name, price: 24_005 }
        expect(result.size).to eq 1
        expect(result[0]).to eq expected_value
      end
    end
  end
end
