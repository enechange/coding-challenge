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
        basic = plan.basic_rate.find { |basic| basic.ampere == @ampere }
        meter = plan.meter_rate.where(max_usage: nil).find { |meter| meter.min_usage < @usage }
        if meter.present?
          price = basic.price + meter.price * @usage
          responce.push({ provider_name: meter.electricity_plan.electric_power_company.name, plan_name: plan.name, price: price })
        else
          next if basic.blank?
          meter = plan.meter_rate.where.not(max_usage: nil).find{ |meter| meter.min_usage < @usage && meter.max_usage >= @usage }
          price = basic.price + meter.price * @usage
          responce.push({ provider_name: meter.electricity_plan.electric_power_company.name, plan_name: plan.name, price: price })
        end
      end
    end
    responce
  end
end