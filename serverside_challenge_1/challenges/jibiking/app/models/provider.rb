class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy

  validates :name, presence: true

  include Common

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "name"]
  end
end
