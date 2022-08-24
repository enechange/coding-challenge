class ElectricityRate
  attr_accessor :ampere, :usage, :result

  def initialize(params)
    @ampere = params[:ampere].to_i
    @usage = params[:usage].to_i
    @result = calculate
  end

  def calculate
    responce = []
    electric_power_companies = ElectricPowerCompany.includes(electricity_plans: :basic_rate).includes(electricity_plans: :meter_rate)
    electric_power_companies.all.each do |company|
      company.electricity_plans.each do |plan|
        basic_rate = plan.basic_rate.find { |basic| basic.ampere == @ampere }
        meter_rate = plan.meter_rate.where(max_usage: nil).find { |meter| meter.min_usage < @usage }
        if meter_rate.present?
          responce.push({ provider_name: meter_rate.electricity_plan.electric_power_company.name, plan_name: plan.name, price: calculate_total(basic_rate, meter_rate) })
        else
          next if basic_rate.blank?
          meter_rate = plan.meter_rate.where.not(max_usage: nil).find{ |meter| meter.min_usage < @usage && meter.max_usage >= @usage }
          responce.push({ provider_name: meter_rate.electricity_plan.electric_power_company.name, plan_name: plan.name, price: calculate_total(basic_rate, meter_rate) })
        end
      end
    end
    responce
  end

  private
    def calculate_total(basic_rate, meter_rate)
      basic_rate.price + meter_rate.price * @usage
    end
end