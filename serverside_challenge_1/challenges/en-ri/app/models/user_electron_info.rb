# frozen_string_literal: true

# requestで受け取った契約アンペア数,電気使用量を保持するclass
# dbと連携しないmodel（validationを使用したいため、modelに定義）
class UserElectronInfo
  include ActiveModel::Model

  attr_accessor :contract_amperage, # 契約アンペア数
                :electricity_usage  # 電気使用量

  validates :contract_amperage,
            presence: { message: '未入力です。' },
            inclusion: { in: Constants::CONTRACT_AMPERAGE_TYPE,
                         message: "#{Constants::CONTRACT_AMPERAGE_TYPE}内、いずれかの数値を入力してください。" }

  ELECTRICITY_USAGE_NUMERIC_ERROR_MESSAGE = "0以上、#{Constants::MAXIMUM_ELECTRICITY_USAGE}以下の整数を入力してください。".freeze

  validates :electricity_usage,
            presence: { message: '未入力です。' },
            numericality: { in: 0..Constants::MAXIMUM_ELECTRICITY_USAGE,
                            message: ELECTRICITY_USAGE_NUMERIC_ERROR_MESSAGE }

  define_model_callbacks :save, only: :before
  before_save { throw(:abort) if invalid? }

  validate :cannot_less_than_zero,
           :cannot_float

  def save
    run_callbacks :save do
      true
    end
  end

  # マイナス数値の場合はsaveさせない
  # ※「in: 0..Constants::MAXIMUM_ELECTRICITY_USAGE」でマイナス数値を除外できなかったので、独自に定義
  def cannot_less_than_zero
    if electricity_usage.instance_of?(Integer) && electricity_usage.negative?
      errors.add(:electricity_usage, ELECTRICITY_USAGE_NUMERIC_ERROR_MESSAGE)
    end
  end

  # 電気使用量は0以上の整数となるため、少数の場合はsaveさせない
  def cannot_float
    errors.add(:electricity_usage, ELECTRICITY_USAGE_NUMERIC_ERROR_MESSAGE) if electricity_usage.instance_of?(Float)
  end
end
