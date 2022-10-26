class ElectronInfoValidator
  include ActiveModel::Model

  attr_accessor :contract_amperage,:electricity_usage

  validates :contract_amperage,
            presence: { message: '未入力です。' },
            inclusion: { in: Constants::CONTRACT_AMPERAGE_TYPE, message: "#{Constants::CONTRACT_AMPERAGE_TYPE}内、いずれかの数値を入力してください。" }

  validates :electricity_usage,
            presence: { message: '未入力です。' },
            numericality: {only_integer: true, greater_than_or_equal_to: 0, message: '正の整数を入力してください。'}
end
