require 'rails_helper'
require 'support/electricity_charge_simulator_validator_helper'

RSpec.describe 'ElectricityChargeSimulatorValidator', type: :model do
  describe '成功' do
    context 'A, kWhともに指定の値が入力された場合' do
      let(:success_value){ ElectricityChargeSimulatorValidator.new(A: 30, kWh: 30) }
      it 'validationに通る' do
        expect(success_value.valid?).to be_truthy
      end
    end
  end

  describe '失敗' do
    let(:error_value){ ElectricityChargeSimulatorValidator.new(A: amp, kWh: kwh) }
    
    describe 'A数誤入力時の動作確認' do
      # kWhは10kWhで固定
      let(:kwh){ 10 }

      context '予期しないA数（指定外）が入力された場合' do
        let(:amp){ 5 }
        include_examples 'validationに通らない'
      end

      context '予期しないA数（マイナス）が入力された場合' do
        let(:amp){ -30 }
        include_examples 'validationに通らない'
      end

      context '予期しないA数（小数点）が入力された場合' do
        let(:amp){ 0.5 }
        include_examples 'validationに通らない'
      end

      context '文字列が入力された場合' do
        let(:amp){ 'test' }
        include_examples 'validationに通らない'
      end

      context 'Aが入力されなかった場合' do
        let(:amp){ '' }
        include_examples 'validationに通らない'
      end
    end

    describe 'kWh誤入力時の動作確認' do
      # Aは30Aで固定
      let(:amp){ 30 }

      context '予期しないkWh数（マイナス）が入力された場合' do
        let(:kwh){ -100 }
        include_examples 'validationに通らない'
      end

      context '予期しないkWh数（小数点）が入力された場合' do
        let(:kwh){ 0.5 }
        include_examples 'validationに通らない'
      end

      context '文字列が入力された場合' do
        let(:kwh){ 'test' }
        include_examples 'validationに通らない'
      end

      context 'kWhが入力されなかった場合' do
        let(:kwh){ '' }
        include_examples 'validationに通らない'
      end
    end
  end
end