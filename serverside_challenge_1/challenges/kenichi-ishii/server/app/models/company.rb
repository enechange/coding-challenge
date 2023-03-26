# 会社名やプラン名等の基本情報を登録しているDBのモデル
class Company < ApplicationRecord
  self.primary_key = "id"
end
