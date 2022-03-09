module Api
  module V1
    class PlansController < ApplicationController
      def index
        get_ampere = params[:ampere]
        get_kwh = params[:kw]
        records = Plan.join_tables.ampere(get_ampere).min_amount(get_kwh).max_amount(get_kwh)
        result = delete_key(calculate_price(store_unit(record_to_hash(records), get_kwh)))

        render json: result
        
      end

      private

        def record_to_hash(records)
          result_hash = records.map{|record| record.attributes}
          return result_hash
        end

        def store_unit(hash, kw)
          count = 0
          hash.each do |h|
            hash[count].store("unit", kw.to_i)
            count +=1
          end
        end

        def calculate_price(hash)
          count = 0
          hash.each do |h|
            price = h["charge"].to_f + h["unit"] * h["unit_price"].to_f
            hash[count].store("price", price)
            count +=1
          end
        end

        def delete_key(hash)
          count = 0
          hash.each do |h|
            h.delete("id")
            h.delete("charge")
            h.delete("unit_price")
            h.delete("unit")
          end
        end

    end
  end
end