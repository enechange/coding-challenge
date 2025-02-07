# frozen_string_literal: true

class FetchElectricityChargeService
  def initialize(simulate_form)
    @simulate_form = simulate_form
  end

  def call
    validate_form!
    fetch_electricity_charges
  end

  private

  def validate_form!
    unless simulate_form.valid?
      raise App::InvalidParameterError, simulate_form.errors.full_messages.join(", ")
    end
  end

  def fetch_electricity_charges
    target_plans.map do |plan|
      calculator_service = plan.calculate_service_class.constantize
      calculator_service.new(
        plan:   plan,
        ampere: simulate_form.ampere.to_i,
        usage:  simulate_form.usage.to_i
      ).call
    end
  end

  def target_plans
    Plan.state_active.includes(:provider, :basic_charges, :usage_charges)
      .where(providers:     { state: Provider.states[:active]    })
      .where(basic_charges: { state: BasicCharge.states[:active] })
      .where(usage_charges: { state: UsageCharge.states[:active] })
  end

  attr_reader :simulate_form
end
