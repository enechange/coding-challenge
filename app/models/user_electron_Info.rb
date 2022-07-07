# requestで受け取った契約アンペア数,電気使用量を保持するclass
# dbと連携しないmodel（validationを使用したいため、modelに定義）
class UserElectronInfo
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :contract_amperage, :integer # 契約アンペア数
  attribute :electricity_usage, :integer # 電気使用量

  validates :contract_amperage,
            presence: true,
            inclusion: { in: Constants::CONTRACT_AMPERAGE_TYPE }

  validates :electricity_usage,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  define_model_callbacks :save, only: :before
  before_save { throw(:abort) if invalid? }

  def save
    run_callbacks :save do
      true
    end
  end
end
