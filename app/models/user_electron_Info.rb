# requestで受け取った契約アンペア数,電気使用量を保持するclass
# dbと連携しないmodel（validationを使用したいため、modelに定義）
class UserElectronInfo
  include ActiveModel::Model

  attr_accessor :contract_amperage, :electricity_usage

  validates :contract_amperage,
            presence: { message: "未入力です。" },
            inclusion: { in: Constants::CONTRACT_AMPERAGE_TYPE,
                         message: "#{Constants::CONTRACT_AMPERAGE_TYPE}内、いずれかの数値を入力してください。" }

  validates :electricity_usage,
            presence: { message: "未入力です。" },
            numericality: { in: 0..Constants::MAXIMUM_ELECTRICITY_USAGE,
                            message: "0以上、#{Constants::MAXIMUM_ELECTRICITY_USAGE}以下の数値を入力してください。" }

  define_model_callbacks :save, only: :before
  before_save { throw(:abort) if invalid? }

  validate :cannot_less_than_zero

  def save
    run_callbacks :save do
      true
    end
  end

  # マイナス数値の場合はsaveさせない
  # ※「in: 0..Constants::MAXIMUM_ELECTRICITY_USAGE」でマイナス数値を除外できなかったので、独自に定義
  def cannot_less_than_zero
    if electricity_usage.instance_of?(Integer) && electricity_usage < 0
      errors.add(:electricity_usage, "0以上、#{Constants::MAXIMUM_ELECTRICITY_USAGE}以下の数値を入力してください。")
    end
  end
end
