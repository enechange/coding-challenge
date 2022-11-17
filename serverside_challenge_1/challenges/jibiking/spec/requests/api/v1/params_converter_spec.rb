require 'rails_helper'

RSpec.describe 'ParamsConverter' do
  include ParamsConverter

  describe '成功' do
    context '整数の場合' do
      let(:int){ convert_params('10') }
      it '変換される' do
        expect(int).to eq 10
      end
    end
  end

  describe '失敗' do
    context '負の整数の場合' do
      let(:minus_int){ convert_params('-10') }
      it '変換されない' do
        expect(minus_int).to eq '-10'
      end
    end

    context '小数の場合' do
      let(:decimal_int){ convert_params('0.5') }
      it '変換されない' do
        expect(decimal_int).to eq '0.5'
      end
    end

    context '文字列の場合' do
      let(:str){ convert_params('test') }
      it '変換されない' do
        expect(str).to eq 'test'
      end
    end

    context '未入力の場合' do
      let(:null_int){ convert_params('') }
      it '変換されない' do
        expect(null_int).to eq ''
      end
    end

    context '数字+文字の場合' do
      let(:str_and_int){ convert_params('10test') }
      it '変換されない' do
        expect(str_and_int).to eq '10test'
      end
    end

    context '文字+数字の場合' do
      let(:int_and_str){ convert_params('test10') }
      it '変換されない' do
        expect(int_and_str).to eq 'test10'
      end
    end
  end
end