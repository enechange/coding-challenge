class PlanCompareParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :ampere
  attribute :amount

  validates :ampere, presence: {
    message: '契約アンペア数を選択してください',
  }
  validates :ampere, inclusion: {
    in: %w(10 15 20 30 40 50 60),
    message: '契約アンペア数は 10 / 15 / 20 / 30 / 40 / 50 / 60 のいずれかから選択してください',
  }

  validates :amount, presence: {
    message: '使用量を入力してください',
  }
  validates :amount, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    message: '使用量は0以上の整数で入力してください',
  }
end
