module Common
  extend ActiveSupport::Concern

  # 文字列が数字（例:1,-1,0.1）の場合、数値に変換する
  def convert_integer(str)
    return str if str.blank? || !str.match?(/^\-?\d\.?(\d+)?$/)
    str.match?(/^\-?\d+?$/) ? str.to_i : str.to_f
  end
end
