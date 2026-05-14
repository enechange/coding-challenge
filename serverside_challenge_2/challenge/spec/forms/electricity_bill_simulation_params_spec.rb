# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityBillSimulationParams do
  def build_params(ampere: '30', kwh: '400')
    described_class.new(ampere: ampere, kwh: kwh)
  end

  describe 'バリデーション' do
    context 'with ampere' do
      it '有効値（30）は valid' do
        expect(build_params(ampere: '30')).to be_valid
      end

      it '上限ぎりぎり kwh=9999 は valid' do
        expect(build_params(kwh: '9999')).to be_valid
      end

      it 'AMPERE_VALUES に含まれない値（25）は invalid' do
        params = build_params(ampere: '25')
        expect(params).to be_invalid
        expect(params.errors[:ampere]).to include(match(/のいずれかを指定/))
      end

      it 'ampere が欠落している場合は blank エラー' do
        params = build_params(ampere: nil)
        expect(params).to be_invalid
        expect(params.errors[:ampere]).to include(match(/必須/))
      end

      it 'ampere が非数値文字列（"abc"）の場合は inclusion エラー' do
        params = build_params(ampere: 'abc')
        expect(params).to be_invalid
        expect(params.errors[:ampere]).to include(match(/のいずれかを指定/))
      end
    end

    context 'with kwh' do
      it 'kwh が欠落している場合は blank エラー' do
        params = build_params(kwh: nil)
        expect(params).to be_invalid
        expect(params.errors[:kwh]).to include(match(/必須/))
      end

      it '負の値（-1）は invalid' do
        params = build_params(kwh: '-1')
        expect(params).to be_invalid
        expect(params.errors[:kwh]).to include(match(/0 以上/))
      end

      it '小数（"100.5"）は invalid' do
        params = build_params(kwh: '100.5')
        expect(params).to be_invalid
        expect(params.errors[:kwh]).to include(match(/整数/))
      end

      it '上限超過（10000）は invalid' do
        params = build_params(kwh: '10000')
        expect(params).to be_invalid
        expect(params.errors[:kwh]).to include(match(/9999 以下/))
      end

      it '非数値文字列（"abc"）は invalid' do
        params = build_params(kwh: 'abc')
        expect(params).to be_invalid
        expect(params.errors[:kwh]).to include(match(/整数/))
      end
    end

    context 'with multiple invalid params' do
      it '両方不正（ampere=25, kwh=-1）は 2 件のエラー' do
        params = build_params(ampere: '25', kwh: '-1')
        expect(params).to be_invalid
        expect(params.errors.count).to eq(2)
      end

      it '両方欠落は 2 件のエラー' do
        params = build_params(ampere: nil, kwh: nil)
        expect(params).to be_invalid
        expect(params.errors.count).to eq(2)
      end
    end
  end

  describe '#jsonapi_errors' do
    it 'status / title / detail / source.parameter のキーを持つ配列を返す' do
      params = build_params(ampere: '25')
      params.valid?

      error = params.jsonapi_errors.first
      expect(error[:status]).to eq('400')
      expect(error[:title]).to eq('Invalid Parameter')
      expect(error[:detail]).to be_a(String)
      expect(error[:source]).to eq({ parameter: 'ampere' })
    end

    it 'エラーが複数ある場合は全件返す' do
      params = build_params(ampere: nil, kwh: nil)
      params.valid?

      expect(params.jsonapi_errors.count).to eq(2)
    end
  end
end
