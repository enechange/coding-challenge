require 'csv'
require 'nkf'

module Utils
  class EnergyPrice
    TYPE_BASIC = 'basic'
    TYPE_CONSUMPTION = 'consumption_fee'
    CONTRACT_ANPERES = [10, 15, 20, 30, 40, 50, 60]

    class << self
      def load_csv
        csv_file = File.read(csv_path)
        encoding = NKF.guess(csv_file)

        CSV.read(csv_path, encoding: encoding, headers: true)
      end

      def each_prices(csv_data, anperes, consumption = 0)
        plan_names.map do |name|
          rows = csv_data.select { |r| r['plan_name'] == name }
          basic_price = find_basic_price(rows, name, anperes)
          consumption_price = find_consumption_price(rows, name, consumption)
          total_price = basic_price + consumption_price
          next if total_price.zero?

          row = rows[0]
          {
            provider_name: row['provider_name'],
            plan_name: row['plan_name_ja'],
            price: total_price,
          }
        end
      rescue
        nil
      end

      private

      def find_basic_price(rows, name, anperes)
        row = rows.find do |r|
          next if r['type'] != TYPE_BASIC
          r['amperes_greater_than'].to_i < anperes && anperes <= r['amperes_up_to'].to_i
        end

        if row.present?
          row['price'].to_f
        end
      end

      def find_consumption_price(rows, name, consumption)
        return consumption if consumption.zero?

        row = rows.find do |r|
          next if r['type'] != TYPE_CONSUMPTION
          is_greater = r['amount_greater_than'].to_f < consumption

          if r['amount_up_to'].present?
            is_greater && consumption <= r['amount_up_to'].to_f
          else
            is_greater
          end
        end

        if row.present?
          row['price'].to_f * consumption
        end
      end

      def plan_names
        load_csv.map {|r| r['plan_name']}.uniq
      end

      def csv_path
        Rails.root.join('config/energy_prices.csv')
      end
    end
  end
end
