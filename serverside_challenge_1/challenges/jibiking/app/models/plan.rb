class Plan < ApplicationRecord
  belongs_to :provider
  has_many :amperages, dependent: :destroy
  has_many :kilowattos, dependent: :destroy

  validates :name, presence: true
  validates :provider_id, presence: true

  include CsvImports

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "name", "provider_id"]
  end
end
