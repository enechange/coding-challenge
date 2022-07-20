# frozen_string_literal: true

module NumericConverter
  extend ActiveSupport::Concern

  # 文字列が整数または小数（例:1,-1,0.1）の場合、整数に変換する
  def convert_string_to_integer_or_float(str)
    return str if str.blank? || !str.match?(/^-?\d\.?(\d+)?$/)

    str.match?(/^-?\d+?$/) ? str.to_i : str.to_f
  end
end
