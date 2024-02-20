class CalculateChargesService
  def initialize(amps, watts)
    @amps = amps.to_i
    @watts = watts.to_i
  end

  def calculate_charges
    electricity_files = Dir.glob(ELECTRICITY_CHARGES_PATH)
    electricity_files.map do |file|
      bill = ElectricityCharges.new(@amps, @watts, file)
      price = bill.calculate
      {
        provider_name: bill.provider_name,
        plan_name: bill.plan_name,
        price: price.is_a?(Numeric) ? price.floor : price
      }
    end
  end
end
