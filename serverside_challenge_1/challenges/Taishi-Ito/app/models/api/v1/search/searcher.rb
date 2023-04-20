class Api::V1::Search::Searcher
  include ActiveModel::Validations

  attr_accessor :ampere,:kwh

  validates :ampere, presence: true, numericality: true, inclusion: { in: [10, 15, 20, 30, 40, 50, 60] }
  validates :kwh, presence: true, numericality: true

  def initialize params
    @ampere = params[:ampere] ? params[:ampere] : nil
    @kwh = params[:kwh] ? params[:kwh] : nil
  end

  def search
    return nil unless @ampere && @kwh
    results = []
    Api::V1::Company.eager_load(:api_v1_plans).all.each do |company|
      plans = company.api_v1_plans
      plans.each do |plan|
        basic_charge = plan.basic_charge(@ampere)
        usage_charge = plan.usage_charge(@kwh)
        next unless basic_charge && usage_charge
        result = {
          "provider_name": company.name,
          "plan_name": plan.name,
          "price": basic_charge + usage_charge,
        }
        results << result
      end
    end
    return results
  end
end
