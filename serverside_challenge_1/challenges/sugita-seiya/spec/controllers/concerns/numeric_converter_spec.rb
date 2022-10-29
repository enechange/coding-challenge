require 'rails_helper'

RSpec.describe NumericConverter do
  include NumericConverter

  describe '文字列型の数字を整数型に変換される確認' do
    context '10進数の数字(0-9)の場合' do
      subject { convert_integer("50") }

      it '変換されること' do
        expect(subject.class).to eq Integer
      end
    end
  end

  describe '文字列型が整数型に変換されない確認' do
    context '未入力の場合' do
      subject { convert_integer("") }

      it '変換されないこと' do
        expect(subject.class).to eq String
      end
    end

    context '文字列の場合' do
      subject { convert_integer("character_string") }

      it '変換されないこと' do
        expect(subject.class).to eq String
      end
    end

    context '小数の場合' do
      subject { convert_integer("100.5") }

      it '変換されないこと' do
        expect(subject.class).to eq String
      end
    end

    context '数字+文字列の場合' do
      subject { convert_integer("100character_string") }

      it '変換されないこと' do
        expect(subject.class).to eq String
      end
    end

    context '記号の場合' do
      subject { convert_integer("!!") }

      it '変換されないこと' do
        expect(subject.class).to eq String
      end
    end
  end
end
