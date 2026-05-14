# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElectricityBillSimulator do
  subject(:result) { described_class.call(ampere: ampere, kwh: kwh) }

  include_context 'with seed data'

  def price_for(plan_name, ampere:, kwh:)
    described_class.call(ampere: ampere, kwh: kwh)
                   .find { |row| row[:plan_name] == plan_name }[:price]
  end

  # 基本料金あり + 従量段階制（東京電力エナジーパートナー / 従量電灯B）
  describe '基本料金あり + 従量段階制 (従量電灯B)' do
    it '0kWh は基本料金のみ' do
      expect(price_for('従量電灯B', ampere: 30, kwh: 0)).to eq 858
    end

    it '第1段階の上限 (120kWh)' do
      expect(price_for('従量電灯B', ampere: 30, kwh: 120)).to eq 3243
    end

    it '第2段階の開始 (121kWh)' do
      expect(price_for('従量電灯B', ampere: 30, kwh: 121)).to eq 3270
    end

    it '第2段階の上限 (300kWh)' do
      expect(price_for('従量電灯B', ampere: 30, kwh: 300)).to eq 8010
    end

    it '第3段階の開始 (301kWh)' do
      expect(price_for('従量電灯B', ampere: 30, kwh: 301)).to eq 8040
    end

    it '複数段階またがり (40A, 400kWh)' do
      expect(price_for('従量電灯B', ampere: 40, kwh: 400)).to eq 11_353
    end
  end

  # 基本料金なし + 従量均一（Looopでんき / おうちプラン）
  describe '基本料金なし + 従量均一 (おうちプラン)' do
    it '0kWh は 0 円' do
      expect(price_for('おうちプラン', ampere: 30, kwh: 0)).to eq 0
    end

    it '通常使用 (400kWh)' do
      expect(price_for('おうちプラン', ampere: 30, kwh: 400)).to eq 11_520
    end
  end

  # アンペア非対応プランの除外（東京ガス / ずっとも電気1）
  describe 'アンペア非対応プランの除外 (ずっとも電気1)' do
    let(:plan_names) { result.pluck(:plan_name) }

    context 'when ampere=20A (ずっとも電気1 は非対応)' do
      let(:ampere) { 20 }
      let(:kwh) { 400 }

      it 'ずっとも電気1 はレスポンスに含まれない' do
        expect(plan_names).not_to include('ずっとも電気1')
      end

      it 'Looop おうちプランは含まれる (基本料金 0 円で計算続行)' do
        expect(plan_names).to include('おうちプラン')
      end
    end
  end

  describe '横断' do
    let(:ampere) { 30 }
    let(:kwh) { 400 }

    it '全プラン対応のアンペアでは全プランが返る' do
      expect(result.size).to eq Plan.count
    end

    it 'price 昇順で並ぶ' do
      prices = result.pluck(:price)
      expect(prices).to eq prices.sort
    end
  end

  describe '戻り値の形' do
    let(:ampere) { 30 }
    let(:kwh) { 400 }

    it '各要素は :provider_name / :plan_name / :price の 3 キーのみを持つ' do
      result.each do |row|
        expect(row.keys).to contain_exactly(:provider_name, :plan_name, :price)
      end
    end

    it ':price は Integer' do
      result.each do |row|
        expect(row[:price]).to be_a(Integer)
      end
    end
  end

  describe '入力バリデーション' do
    it 'サポート外のアンペア (25A) で ArgumentError' do
      expect { described_class.call(ampere: 25, kwh: 400) }.to raise_error(ArgumentError, /ampere/)
    end

    it '0A (集合外) で ArgumentError' do
      expect { described_class.call(ampere: 0, kwh: 400) }.to raise_error(ArgumentError, /ampere/)
    end

    it '負の kWh で ArgumentError' do
      expect { described_class.call(ampere: 30, kwh: -1) }.to raise_error(ArgumentError, /kwh/)
    end

    it 'MAX_KWH を超えた kwh で ArgumentError' do
      expect { described_class.call(ampere: 30, kwh: 10_000) }.to raise_error(ArgumentError, /kwh/)
    end

    it 'Integer に coerce できないアンペアで例外' do
      expect { described_class.call(ampere: 'abc', kwh: 400) }.to raise_error(StandardError)
    end

    it 'float のアンペアで ArgumentError (丸めず弾く)' do
      expect { described_class.call(ampere: 30.0, kwh: 400) }.to raise_error(ArgumentError, /ampere/)
    end

    it 'float の kWh で ArgumentError (丸めず弾く)' do
      expect { described_class.call(ampere: 30, kwh: 400.5) }.to raise_error(ArgumentError, /kwh/)
    end

    it 'Integer-coercible な文字列は正常に計算できる' do
      coerced = described_class.call(ampere: '30', kwh: '400')
      direct = described_class.call(ampere: 30, kwh: 400)
      expect(coerced).to eq direct
    end
  end
end
