module Api
  module V1
    class SimulateController < ApplicationController
      
      def simulate
        @ampere = params[:ampere]
        @kw = params[:kw]
        basic_charges = Plan.joins(:basic_charges).select('plans.id, plans.provider_name, plans.plan, basic_charges.charge').where(basic_charges: {ampere: @ampere})
        
        @results = basic_charges.map{|basic_charges| basic_charges.attributes}
        result_count = 0
        
        @results.each do |result|
          commodity_charge = CommodityCharge.where(plan_id: result["id"]).where('min_amount <= ?', @kw).where('max_amount >= ?', @kw).limit(1)
          price = result["charge"].to_f + @kw.to_i * commodity_charge[0].unit_price.to_f
          @results[result_count].store("price", price)
          result_count += 1
        end

        render json: @results
      end
    end
  end
end
