# 基本料金を登録しているDBのモデル
class BasicCharge < ApplicationRecord
  belongs_to :company
end
