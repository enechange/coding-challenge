module Api
  module V1
    class ElectricityChargeSimulation
      AMPERE_LIST = [10, 15, 20, 30, 40, 50, 60]
      MAX_USAGE = 99999

      attr_accessor :ampere, :usage, :result

      def initialize(params)
        @ampere = params[:ampere].to_i
        @usage = params[:usage].to_i
        @result = simulate_charge_plan
      end

      def simulate_charge_plan
        basic_fee_list = BasicFee.where(ampere: @ampere)
        prices = basic_fee_list.map do |bf|
          res = bf.base_fee + electricity_charge(bf.plan)
          { provider_name: bf.plan.provider.name, plan_name: bf.plan.name, price: res }
        end
      end

      private

        def base_charge(plan)
          BasicFee.find_by(plan_id: plan.id, ampere: @ampere).base_fee
        end

        def electricity_charge(plan)
          UsageCharge.where(plan: plan).where('min_usage <= ?', @usage).inject(0) do |electricity_charge, usage_class|
            if @usage <= usage_class.max_usage || usage_class.max_usage.nil?
              electricity_charge + usage_class.unit_usage_fee * (@usage - usage_class.min_usage)
            else
              electricity_charge + usage_class.unit_usage_fee * (usage_class.max_usage - usage_class.min_usage)
            end
          end
        end
    end
  end
end
