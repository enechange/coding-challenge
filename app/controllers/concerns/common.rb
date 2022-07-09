module Common
  extend ActiveSupport::Concern

  # 文字列が数字の場合、数値に変換する
  def convert_integer(str)
    return str if str.blank? || !str.match?(/^(\-)?[0-9]+$/)
    str.to_i
  end
end
