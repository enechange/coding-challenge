class PowerSupplyPlanSimulator
  VALID_AMPS = [10, 15, 20, 30, 40, 50, 60].freeze

  def initialize(amp, meter_rate)
    @amp = amp
    @meter_rate = meter_rate
    @errors = []
  end

  def call
    unless validate_params
      return {
        error: {
          code: 400,
          message: @errors.join('\n')
        }
      }
    end

    result = []
    PowerSupplyPlan.includes(:provider, :meter_rate_charges, :basic_charges).each do |plan|
      calculate_result = plan.calculate_total_amount(@amp, @meter_rate)
      next unless calculate_result

      result << {
        "provider_name": plan.provider.name,
        "plan_name": plan.name,
        "price": calculate_result
      }
    end
    result
  end

  def validate_params
    if @amp.blank?
      @errors << "リクエストパラメータ 'amp' が不足しています。"
    else
      @errors << "リクエストパラメータ 'amp' の値が不正です。'10 / 15 / 20 / 30 / 40 / 50 / 60' のいずれかの値を指定してください。" unless valid_amp?(@amp)
    end
    if @meter_rate.blank?
      @errors << "リクエストパラメータ 'meter_rate' が不足しています。"
    else
      unless numeric?(@meter_rate) && @meter_rate.to_i >= 0
        @errors << "リクエストパラメータ 'meter_rate' の値が不正です。0以上の整数を指定してください。"
      end
    end
    @errors.blank?
  end

  def numeric?(string)
    Integer(string)
    true
  rescue ArgumentError, TypeError
    false
  end

  def valid_amp?(amp)
    VALID_AMPS.include?(amp.to_i)
  end
end
