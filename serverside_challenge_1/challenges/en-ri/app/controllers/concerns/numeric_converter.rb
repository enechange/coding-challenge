# frozen_string_literal: true

module NumericConverter
  extend ActiveSupport::Concern

  # 文字列が整数（例:1,-1）の場合、整数に変換する
  def convert_integer(str)
    return str if str.blank? || !str.instance_of?(String) || !str.match?(/^-?\d+$/)

    str.to_i
  end

  # 文字列が小数（例:0.1）の場合、小数に変換する
  def convert_float(str)
    return str if str.blank? || !str.instance_of?(String) || !str.match?(/^-?\d+\.\d+$/)

    str.to_f
  end
end
