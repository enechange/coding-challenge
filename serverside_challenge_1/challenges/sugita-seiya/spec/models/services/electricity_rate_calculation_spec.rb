require 'rails_helper'

RSpec.describe ElectricityRateCalculation, type: :service do
  # 東京電力エナジーパートナー/従量電灯Bプランを参照
  let(:plan) { ElectricityRatePlan.find(1) }

  describe '基本料金＋従量料金の計算結果の確認(東京電力エナジーパートナー/従量電灯Bを参照)' do
    describe '契約アンペア数の増加確認' do
      context '契約アンペア数10A、電気使用量100kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 100)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '2274円であること' do
          expect(subject).to eq 2274
        end
      end

      context '契約アンペア数15A、電気使用量100kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 15, electricity_usage: 100)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '2417円であること' do
          expect(subject).to eq 2417
        end
      end

      context '契約アンペア数20A、電気使用量100kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 20, electricity_usage: 100)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '2560円であること' do
          expect(subject).to eq 2560
        end
      end

      context '契約アンペア数30A、電気使用量100kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 30, electricity_usage: 100)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '2846円であること' do
          expect(subject).to eq 2846
        end
      end

      context '契約アンペア数40A、電気使用量100kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 40, electricity_usage: 100)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '3132円であること' do
          expect(subject).to eq 3132
        end
      end

      context '契約アンペア数50A、電気使用量100kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 50, electricity_usage: 100)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '3418円であること' do
          expect(subject).to eq 3418
        end
      end

      context '契約アンペア数60A、電気使用量100kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 60, electricity_usage: 100)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '3704円であること' do
          expect(subject).to eq 3704
        end
      end
    end

    describe '使用量(kWh)の増加確認(東京電力エナジーパートナー/従量電灯Bを参照)' do
      context '契約アンペア数10A、電気使用量0kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 0)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '286円であること' do
          expect(subject).to eq 286
        end
      end

      context '契約アンペア数10A、電気使用量100kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 100)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '2274円であること' do
          expect(subject).to eq 2274
        end
      end

      context '契約アンペア数10A、電気使用量150kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 150)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '3466円であること' do
          expect(subject).to eq 3466
        end
      end

      context '契約アンペア数10A、電気使用量200kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 200)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '4790円であること' do
          expect(subject).to eq 4790
        end
      end

      context '契約アンペア数10A、電気使用量250kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 250)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '6114円であること' do
          expect(subject).to eq 6114
        end
      end

      context '契約アンペア数10A、電気使用量300kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 300)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '7138円であること' do
          expect(subject).to eq 7438
        end
      end

      context '契約アンペア数10A、電気使用量350kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 350)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '8966円であること' do
          expect(subject).to eq 8966
        end
      end

      context '契約アンペア数10A、電気使用量400kWhの場合' do
        let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 400)}
        subject { ElectricityRateCalculation.calculation_electricity_charge(plan, electron_info) }

        it '10495円であること' do
          expect(subject).to eq 10495
        end
      end
    end
  end

  describe '基本料金の確認(東京電力エナジーパートナー/従量電灯Bを参照)' do
    context '契約アンペア数10Aの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 100)}
      subject { ElectricityRateCalculation.calculation_basic_charge(plan, electron_info) }

      it '286円であること' do
        expect(subject).to eq 286
      end
    end

    context '契約アンペア数15Aの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 15, electricity_usage: 100)}
      subject { ElectricityRateCalculation.calculation_basic_charge(plan, electron_info) }

      it '429円であること' do
        expect(subject).to eq 429
      end
    end

    context '契約アンペア数20Aの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 20, electricity_usage: 100)}
      subject { ElectricityRateCalculation.calculation_basic_charge(plan, electron_info) }

      it '572円であること' do
        expect(subject).to eq 572
      end
    end

    context '契約アンペア数30Aの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 30, electricity_usage: 100)}
      subject { ElectricityRateCalculation.calculation_basic_charge(plan, electron_info) }

      it '858円であること' do
        expect(subject).to eq 858
      end
    end

    context '契約アンペア数40Aの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 40, electricity_usage: 100)}
      subject { ElectricityRateCalculation.calculation_basic_charge(plan, electron_info) }

      it '1144円であること' do
        expect(subject).to eq 1144
      end
    end

    context '契約アンペア数50Aの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 50, electricity_usage: 100)}
      subject { ElectricityRateCalculation.calculation_basic_charge(plan, electron_info) }

      it '1430円であること' do
        expect(subject).to eq 1430
      end
    end

    context '契約アンペア数60Aの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 60, electricity_usage: 100)}
      subject { ElectricityRateCalculation.calculation_basic_charge(plan, electron_info) }

      it '1716円であること' do
        expect(subject).to eq 1716
      end
    end
  end

  describe '従量料金の計算結果の確認(東京電力エナジーパートナー/従量電灯Bを参照)' do
    context '電気使用量が0kWhの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 0)}
      subject { ElectricityRateCalculation.calculation_usage_charge(plan, electron_info) }

      it '0円であること' do
        expect(subject).to eq 0
      end
    end

    context '電気使用量が50kWhの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 50)}
      subject { ElectricityRateCalculation.calculation_usage_charge(plan, electron_info) }

      it '994円であること' do
        expect(subject).to eq 994
      end
    end

    context '電気使用量が100kWhの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 100)}
      subject { ElectricityRateCalculation.calculation_usage_charge(plan, electron_info) }

      it '1988円であること' do
        expect(subject).to eq 1988
      end
    end

    context '電気使用量が200kWhの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 200)}
      subject { ElectricityRateCalculation.calculation_usage_charge(plan, electron_info) }

      it '4504円であること' do
        expect(subject).to eq 4504
      end
    end

    context '電気使用量が300kWhの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 300)}
      subject { ElectricityRateCalculation.calculation_usage_charge(plan, electron_info) }

      it '7152円であること' do
        expect(subject).to eq 7152
      end
    end

    context '電気使用量が400kWhの場合' do
      let(:electron_info) { ElectronInfoValidator.new(contract_amperage: 10, electricity_usage: 400)}
      subject { ElectricityRateCalculation.calculation_usage_charge(plan, electron_info) }

      it '10209円であること' do
        expect(subject).to eq 10209
      end
    end
  end
end
