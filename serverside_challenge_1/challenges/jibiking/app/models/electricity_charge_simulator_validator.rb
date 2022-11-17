class ElectricityChargeSimulatorValidator
  include ActiveModel::Model

  attr_accessor :A,:kWh

  AMPERAGES = [10, 15, 20, 30, 40, 50, 60]

  validates :A, presence: { message: 'Aが未入力です。' }, inclusion: { in: AMPERAGES, message: "Aには#{AMPERAGES}のいずれかの値を入力してください" }
  validates :kWh, presence: { message: 'kWhが未入力です。' }, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: 'kWhには0以上の整数を入力してください'}
end
