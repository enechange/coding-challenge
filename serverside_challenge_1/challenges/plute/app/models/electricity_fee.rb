class ElectricityFee
  AMPERE = [10, 15, 20, 30, 40, 50, 60]

  attr_accessor :plan, :ampere, :usage, :fee

  def initialize(plan:, ampere:, usage:)
    @plan = plan
    @ampere = ampere
    @usage = usage
  end

  def calclate
    @fee = base_fee + usage_fee
  end

  private

  def base_fee
    base_fee = BaseFee.where(plan: @plan, ampere: @ampere).first
    base_fee.base_fee
  end

  def usage_fee
    UsageFee.where(plan: @plan).where('min_usage < ?', @usage).inject(0) do |usage_fee, u|
      usage_fee += u.unit_usage_fee * [(@usage - u.min_usage), (u.max_usage - u.min_usage)].min
    end
  end
end