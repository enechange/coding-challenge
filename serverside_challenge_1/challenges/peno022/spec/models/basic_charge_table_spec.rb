# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BasicChargeTable, type: :model do
  let(:unit_prices) { { 20 => 1000, 30 => 2000, 40 => 3000 } }
  let(:basic_charge_table) { described_class.new(unit_prices) }

  describe '#calculate_charge' do
    context '契約区分にあるアンペア数のとき' do
      it '契約アンペア数に対応する基本料金を返す' do
        expect(basic_charge_table.calculate_charge(30)).to eq 2000
      end
    end

    context '契約区分にないアンペア数のとき' do
      it 'nilを返す' do
        expect(basic_charge_table.calculate_charge(50)).to be_nil
      end
    end
  end
end
